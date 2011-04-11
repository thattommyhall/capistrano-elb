Gem::Specification.new do |s|
  s.name = "capistrano-elb"
  s.version = "0.2.5"
  s.authors = ["thattommyhall"]
  s.date = '2011-04-11'
  s.files = ["lib/capistrano-elb.rb", "lib/capistrano-elb/tasks.rb"]
  s.summary = "Automagically remove/readd servers from EC2 load balancers as you cap deploy"
  s.require_paths = ["lib"]
  # s.rubygems_version = "1.3.5"
  s.add_dependency('fog')
  s.add_dependency('excon')
  
  s.description = "Automagically remove/readd servers from EC2 load balancers as you cap deploy"
  s.email = "tom.hall@forward.co.uk"

  s.homepage = %q{https://github.com/thattommyhall/capistrano-elb}
end