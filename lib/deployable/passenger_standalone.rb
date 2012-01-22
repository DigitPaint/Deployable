# = Passenger Standalone related recipes
#
# These tasks handle setup of server.yml to use in combination
# with the DP init.d script for passenger standalone installations (see examples/scripts/initd.rb)
#
# 
require 'yaml'
Capistrano::Configuration.instance(true).load do
  namespace :passenger_standalone do
    desc "Setup server.yml in the 'deploy_to' directory"
    task :setup, :roles => [:app] do    
      config = fetch(:passenger_standalone)
      config = deep_stringify_keys(config)
      unless config["rvm"] && config["rvm"]["rvm_ruby_string"]
        config["rvm"] ||= {}
        config["rvm"]["rvm_ruby_string"] = fetch(:rvm_ruby_string)
      end
      
      put config.to_yaml, "#{deploy_to}/server.yml"      
    end
  end
  
  # Helper method to make all keys of the config strings
  def deep_stringify_keys(hash)
    hash.inject({}) do |mem, (k,v)|
      if v.kind_of?(Hash)
        mem[k.to_s] = deep_stringify_keys(v)
      else
        mem[k.to_s] = v
      end
      mem
    end
  end
end
