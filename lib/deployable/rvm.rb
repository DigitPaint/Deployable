# = RVM related tasks
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
  end
end