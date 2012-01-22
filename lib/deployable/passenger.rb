# = Passenger related recipes
#
# These tasks overwrite the default start/stop/restart tasks for deployment
# With passenger we only need to touch 'CURRENT_PATH/tmp/restart.txt'
#
# Warning: This overwrites the default deploy:restart, deploy:start and deploy:stop tasks
Capistrano::Configuration.instance(true).load do
  
  namespace :deploy do
    task :restart, :roles => [:app] do
      run "touch #{current_path}/tmp/restart.txt"  
    end      
    
    task :start, :roles => [:app] do
      # do nothing
    end

    task :stop, :roles => [:app] do
      # do nothing
    end
    
  end
  
end