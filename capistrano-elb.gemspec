Gem::Specification.new do |s|
  s.name = "capistrano-elb"
  s.version = "0.1"
  s.authors = ["thattommyhall"]
  s.files = ["lib/capistrano-elb.rb", "lib/capistrano-elb/tasks.rb"]
  s.summary = "add/remove servers from ELB loadblancers automagically"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.5"
  s.add_dependency('fog')
  s.add_dependency('excon')
  
  s.description = "Remove servers automagically from ELB before deploy"
  s.email = "tom.hall@forward.co.uk"

  s.homepage = %q{http://www.thattommyhall.com}
end