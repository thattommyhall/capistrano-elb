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

(Equivalent to having the following in your deploy.rb)
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

The first time you run it a record of the ELB setup is saved to config/lbs.yaml, you can update/chech this with 
    cap elb:check
    cap elb:save
    

