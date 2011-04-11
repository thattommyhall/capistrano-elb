# CapistranoELB
A simple library to control Amazon Elastic Load Balancers for use within Capistrano

## Install
gem install capistrano-elb

## Usage
require "capistrano-elb/tasks"

This will instantiate an instance of the CapELB class and add hooks to remove/readd before/after deploys

requiring "tasks" is equivalent to having the folling in your deploy.rb


> namespace :elb do
>   capELB = CapELB.new()
>   
>   task :remove do 
>     servers = roles[:web].servers.map {|server| server.host}
>     pp servers
>     capELB.remove servers
>   end
> 
>   task :add do 
>     servers = roles[:web].servers.map {|server| server.host}
>     capELB.add servers
>   end
>   
>   task :save do
>     capELB.save_config
>   end
>   
>   task :check do 
>     puts capELB.check_config
>   end
> end
> 
> before "deploy", "elb:remove"
> after "deploy", "elb:add"


You can do 
cap elb:save