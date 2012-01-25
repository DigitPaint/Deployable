# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "deployable/version"

Gem::Specification.new do |s|
  s.name        = "deployable"
  s.version     = Deployable::VERSION
  s.authors     = ["Digitpaint", "Flurin Egger"]
  s.email       = ["info@digitpaint.nl", "flurin@digitpaint.nl"]
  s.homepage    = "https://github.com/DigitPaint/Deployable"
  s.summary     = %q{A collection of handy capistrano tasks and recipes}
  s.description = %q{This library contains commonly used capistrano tasks, a couple of default recipes and example configurations.}

  s.rubyforge_project = "deployable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "capistrano", "~> 2.9.0"
  s.add_runtime_dependency "capistrano-ext", "~> 1.2.1"
  
  # This may be deleted in future versions. Needed because in older
  # rubies you get Abort Trap 6 errors in gem 
  # s.add_runtime_dependency "highline", "1.5.2"
end
