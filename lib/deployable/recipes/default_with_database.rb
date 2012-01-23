# This is our default deployment script with database support and assumes the following
#
# - Capistrano Multistage
# - RVM
# - Passenger
# - Passenger Standalone
# - Bundler
#
# - Database config

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

# Handle database config
require "deployable/database"
after "deploy:setup", "database:setup"
after "deploy:update_code", "database:copy_config_to_release"

# Passenger standalone setup
require "deployable/passenger_standalone"
after "deploy:setup", "passenger_standalone:setup"

# Cleanup
after "deploy", "deploy:cleanup"
