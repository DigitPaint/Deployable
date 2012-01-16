# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "deployable/version"

Gem::Specification.new do |s|
  s.name        = "deployable"
  s.version     = Deployable::VERSION
  s.authors     = ["Digitpaint", "Flurin Egger"]
  s.email       = ["info@digitpaint.nl", "flurin@digitpaint.nl"]
  s.homepage    = ""
  s.summary     = %q{A collection of handy capistrano deploy recipes}
  s.description = s.summary

  s.rubyforge_project = "deployable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
