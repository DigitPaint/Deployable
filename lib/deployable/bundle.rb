# = Bundler 1.0.x related tasks
# 
# == Usage
# For some dependencies you need extra config parameters. Bundler supports these by setting "bundle config ...."
# Our config takes care of this serverside. All you need to do are
#
# Set: "after 'deploy:finalize_update', 'bundle:config'" (you may want to run this after your RVM setup though)
#
# Set the config like this:
#
# set :bundle_config, {
#   :build => {
#     :mysql => "--with-mysql-config='/usr/bin/mysql_config'"
#   }
# }
# 
# == Caution!
# Warning: Do not load these with bundler below 1.0.x
# 
Capistrano::Configuration.instance(true).load do
  namespace :bundle do
    desc "Setup bundler config on server"
    task :config do
      if conf = fetch(:bundle_config)
        conf.each do |k1,h|
          h.each do |k2,v|
            bundle_cmd     = fetch(:bundle_cmd, "bundle")
            bundle_dir     = fetch(:bundle_dir, File.join(fetch(:shared_path), 'bundle'))          
          
            current_release = fetch(:current_release)
            if current_release.to_s.empty?
              raise ::Capistrano::CommandError.new("Cannot detect current release path - make sure you have deployed at least once.")
            end
                    
            args = ["#{k1}.#{k2} #{v}"]
            args << "--path #{bundle_dir}" unless bundle_dir.to_s.empty?
          
            run "cd #{current_release} && #{bundle_cmd} config #{args.join(" ")}"
          end
        end
      end
    end
  end

end
