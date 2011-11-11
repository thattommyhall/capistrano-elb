# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capistrano-elb/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-elb"
  s.version     = Capistrano::Elb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["thattommyhall"]
  s.email       = ["tom.hall@forward.co.uk"]
  s.homepage    = "https://github.com/thattommyhall/capistrano-elb"
  s.summary     = %q{Automagically remove/readd servers from EC2 load balancers as you cap deploy}
  s.description = %q{Capistrano plugin for removing/readd servers to EC2 load balancers}

  s.rubyforge_project = "capistrano-elb"

  s.add_dependency('fog', '0.11.0')
  # s.add_dependency('excon')
  s.add_dependency('capistrano')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
