# = Directory related recipes
#
# These scripts make sure you have all the directories you need 
# 
# == Usage
# 
#   set :directories, ["dir", "dir", "dir"]
# 
Capistrano::Configuration.instance(true).load do
  namespace :directories do
    desc "Creates all the directories in var :directories"
    task :create, :roles => [:app] do
      if dirs = fetch(:directories)
        dirs.each do |dir|
          dir = dir.call if dir.respond_to?(:call)
          run "mkdir -p #{dir}"
        end
      end
    end
  end
end
