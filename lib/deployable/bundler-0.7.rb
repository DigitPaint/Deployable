# = Bundler 0.7.x related tasks
# 
# Warning: Do not load 0.7.x AND 1.0.x tasks at the same time!
Capistrano::Configuration.instance(true).load do
  namespace :bundler do
    desc "Setup bundler dirs in shared"
    task :setup, :roles => [:app] do
      run "mkdir -p #{deploy_to}/shared/bundler_gems/gems #{deploy_to}/shared/bundler_gems/specifications"
    end
  
    desc "Bundle gems in release_path/vendor/bundler_gems (symlinked to shared)"
    task :bundle, :roles => [:app] do
      run "cd #{release_path}/vendor/bundler_gems; ln -fs #{deploy_to}/shared/bundler_gems/gems"
      run "cd #{release_path}/vendor/bundler_gems; ln -fs #{deploy_to}/shared/bundler_gems/specifications"
      run "cd #{release_path}; gem bundle --cached"
    end
    
    desc "Install bundler"
    task :install, :roles => [:app] do
      run "gem install bundler --version=0.7.2"
    end    
  end
end