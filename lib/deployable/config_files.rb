# = Config files
#
# Allows you to upload stage dependent config files with multiple strategies
#
# == Usage
# 
# == Example
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
      if configs = fetch(:config_files)
        configs.inject({}) do |mem, (filename, options)|
          if options.kind_of?(String)
            mem[filename] = {:location => options, :strategy => :put}
          else
            mem[filename] = options
          end
          mem
        end
      else
        {}
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