# = RVM related tasks
# 
# These tasks make working with RVM and gemsits a little bit easier. 
#
# == Usage
# We want to be able to set the defined RVMRC in the deploy script
# on the server too. To achieve this we have to set the RVMRC 
# after every deploy and we have to trust the just created RVMRC too.
#
# == Example
# require 'deployable/rvm'
# before "deploy:setup", "rvm:create_gemset"
# after "deploy:update_code", "rvm:set_rvmrc", "rvm:trust_rvmrc"
# 
Capistrano::Configuration.instance(true).load do
  namespace :rvm do
    desc "Trust the RVMRC in release_path"
    task :trust_rvmrc do
      run "rvm rvmrc trust #{release_path}"
    end
  
    desc "Set an RVMRC according to the rubystring in release_path"
    task :set_rvmrc, :roles => [:app] do
      put "rvm use #{rvm_ruby_string}", "#{release_path}/.rvmrc"
    end
    
    desc "Create the gemset"
    task :create_gemset, :roles => [:app] do
      ruby,gemset = rvm_ruby_string.split("@")
      run "rvm gemset create #{gemset}"
    end
  end
end