# = Config files
#
# Allows you to upload stage dependent config files with multiple strategies
#
# == Usage
#
# All you have to do is set the variable :config_files with the following structure:
#
#   set :config_files, {
#     "test.rb"  => "#{current_release}/test.rb",
#     "local.rb" => {
#       :location  => "#{current_release}/config/local.rb",
#       :strategy => :put
#     },
#     "skyline_configuration.rb" => {
#       :location => "#{current_release}/config/initializers/skyline_configuration.rb",
#       :strategy => :copy
#     }
#   }   
# 
# Every key of the hash above is a filename of a file that resides in <tt>:stage_dir/:stage</tt> (default=config/deploy/:stage)
# The filename kan either be filename.xyz or filename.xyz.erb. If both a regular and an .erb variant are present, only the
# .erb variant is processed. And you guessed right: the .erb variant is processed by ERB before putting.
#
# The value of the hash can either be a string or another hash. The config_file configuration hash has the folowing keys
#
# [:location]   The location the file will be stored on the server after deployment (final location)
# [:strategy]   The strategy defines how the file will be stored on the server. The default strategy is :put, see below for more info
# 
# The most simple usage is just "filename.xyz" => "location.xyz" this will assume the default strategy of :put.
#
# === Strategies
#
# [:put]   The file will be processed (in case of ERB) and uploaded during every deploy
# [:copy]  The file will be processed and uploaded once during setup and after that it'll be copied to the final location on each deploy
# 
Capistrano::Configuration.instance(true).load do
  
  namespace :config_files do
    desc "Setup config files with strategy :copy"
    task :setup do
      normalize_configs.each do |filename, options|
        next unless options[:strategy] == :copy
        put render_config_file(filename), "#{deploy_to}/#{filename}"
      end
    end
    
    desc "Set all config files for current stage"
    task :install do      
      normalize_configs.each do |filename, options|
        case options[:strategy]
        when :put
          put render_config_file(filename), options[:location]
        when :copy
          run "cp #{deploy_to}/#{filename} #{options[:location]}"
        end
      end
    end
    
    # Normalize config files so we can do {"filename.rb" => "location"} instead
    # of the full syntax. The default strategy is :put
    def normalize_configs
      if configs = fetch(:config_files, {})
        configs.inject({}) do |mem, (filename, options)|
          if !options.kind_of?(Hash)
            options = {:location => options, :strategy => :put}
          end
          mem[filename] = {}
          options.each do |k,v|
            mem[filename][k] = interpolate(v)
          end
          mem
        end
      end      
    end
    
    def interpolate(var)
      if var.respond_to?(:call)
        var.call
      else
        var
      end
    end
    
    def render_config_file(file)
      location = Pathname.new(fetch(:stage_dir, "config/deploy")) + stage.to_s
      if File.exist?(location + "#{file}.erb")
        view = ERB.new(File.read(location + "#{file}.erb"))
        view.result(binding)
      elsif File.exist?(location + file)
        File.read(location + file)
      else
        raise ::Capistrano::CommandError.new("Cannot detect current config file in #{location}.")
      end
    end
  end
end