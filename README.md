# CapistranoELB
A simple library to control Amazon Elastic Load Balancers for use within Capistrano

## Install
gem install capistrano-elb

## Usage
You should have ec2credentials.yaml in the same directory as your cap files

    #ec2credentials.yaml
    --- 
    :aws_access_key_id: YOUR_KEY_ID_
    :aws_secret_access_key: YOUR_KEY

then just 
    
    require "capistrano-elb/tasks"

This will instantiate an instance of the CapELB class and add hooks to remove/readd before/after deploys

As of version 0.4.0 it looks for an 'elb' tag with value of the name of a loadbalancer to decide when to remove/readd servers.

(Equivalent to having the following in your deploy.rb)

    require "capistrano-elb"
    
    namespace :elb do
      capELB = CapELB.new()

      task :remove do 
        servers = roles[:web].servers.map {|server| server.host}
        puts "Removing #{servers} from ELB"
        capELB.remove servers
      end

      task :add do 
        servers = roles[:web].servers.map {|server| server.host}
        puts "Adding #{servers} to ELB"
        capELB.add servers
      end

      task :check do 
        puts capELB.check_config
      end
    end

    before "deploy", "elb:remove"
    after "deploy", "elb:add"

You can just require capistrano-elb and do whatever you want inside your deploy scripts of course

If you want to hook after deploy but before the elb:add you can target 
    after deploy:restart :your_task
