require "capistrano-elb"
require "pp"

Capistrano::Configuration.instance(:must_exist).load do
  namespace :elb do
    capELB = CapELB.new()
    
    task :remove do 
      servers = roles[:web].servers.map {|server| server.host}
      pp servers
      capELB.remove servers
    end

    task :add do 
      servers = roles[:web].servers.map {|server| server.host}
      capELB.add servers
    end
    
    task :save do
      capELB.save_config
    end
    
    task :check do 
      puts capELB.check_config
    end
  end

  before "deploy", "elb:remove"
  after "deploy", "elb:add"
end