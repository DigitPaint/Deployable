# This is our default deployment script without database support and assumes the following
#
# - Capistrano Multistage
# - RVM
# - Passenger
# - Passenger Standalone
# - Bundler

Capistrano::Configuration.instance(true).load do
  # Load multistage
  require 'capistrano/ext/multistage'

  # Load RVM
  require 'rvm/capistrano'

  # Overwrite the start/stop/restart tasks
  require 'deployable/passenger'

  # Add RVM specific tools
  require "deployable/rvm"
  before "deploy:setup", "rvm:create_gemset"
  after "deploy:finalize_update", "rvm:set_rvmrc", "rvm:trust_rvmrc"

  # Enable bundling
  require 'bundler/capistrano'
  require "deployable/bundle"
  after "rvm:trust_rvmrc", "bundle:config"

  # Passenger standalone setup
  require "deployable/passenger_standalone"
  after "deploy:setup", "passenger_standalone:setup"

  # Config files support
  require "deployable/config_files"
  after "deploy:setup", "config_files:setup"
  after "deploy:update_code", "config_files:install"
  
  # Directories support
  require 'deployable/directories'
  after "deploy:update_code", "directories:create"

  # Cleanup
  after "deploy", "deploy:cleanup"
end