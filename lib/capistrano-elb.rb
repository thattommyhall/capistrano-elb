require 'fog'
require 'yaml'
require 'capistrano'
require 'pp'

class CapELB
  def initialize(configdir=File.join(Dir.pwd, 'config'))
    ec2credentials = YAML::load(File.open(File.join(configdir, 'ec2credentials.yaml')))
    aws = Fog::Compute.new(ec2credentials.merge({:provider=>'AWS'}))
    @regions = aws.describe_regions.body["regionInfo"].map {|region| region["regionName"]}

    @compute = {}
    @regions.each do |region|
      @compute.merge!(region => Fog::Compute.new(ec2credentials.merge({:provider=>'AWS',:region=>region})))
    end

    @elb = {}
    @regions.each do |region|
      @elb.merge!(region => Fog::AWS::ELB.new(ec2credentials.merge(:region=>region)))
    end
    
    @lbsfile = File.join(configdir, 'lbs.yaml') 
    
    @lbs = load_config
  end
  
  def config_from_aws
    lbs = {}
    @regions.each do |region| 
      loadBalancerDescriptions = 
        @elb[region].describe_load_balancers.body["DescribeLoadBalancersResult"]["LoadBalancerDescriptions"]
      loadBalancerDescriptions.each do |lb|
        lbs.merge!({region => {lb["LoadBalancerName"] => lb["Instances"]}})
      end
    end
    lbs
  end
  
  def save_config
    File.open( @lbsfile, 'w' ) do |file|
       YAML.dump( config_from_aws, file )
    end
  end
  
  def load_config
    unless File.exists? @lbsfile
       save_config
     end
    YAML::load(File.open(@lbsfile))
  end
  
  def check_config
    current = config_from_aws
    errors = []
    load_config.each_pair do |region,lbs|
      lbs.each_pair do |lbname, target_instances|
        missing = target_instances - current[region][lbname]
        extra = current[region][lbname] - target_instances
        errors << "#{missing} are missing from #{region}/#{lbname}" unless missing.empty?
        errors << "#{extra} should not be in #{region}/#{lbname}" unless extra.empty?
      end
    end
    puts (errors.empty? ? "ELB config correct" : errors) 
  end
  
  def add(serverlist)
    each_server_by_lbs(serverlist) do |region, lbname, servers|
      region.register_instances_with_load_balancer(servers, lbname)
    end
  end
  
  def remove(serverlist)
    each_server_by_lbs(serverlist) do |region, lbname, servers|
      region.deregister_instances_from_load_balancer(servers, lbname)
    end
  end
  
  def each_server_by_lbs(serverlist)
    @lbs.each_pair do |region, lbs|
      lbs.each_pair do |lbname, target_instances|
        to_change = @compute[region].servers.select{|server| serverlist.include? server.dns_name}.map{|server| server.id}
        yield(@elb[region], lbname, to_change) unless to_change.empty?
      end
    end
  end
end