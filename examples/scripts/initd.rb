#!/usr/bin/env ruby

# chkconfig: - 85 15
# description:  Passenger Standalone
require 'yaml'
require 'pathname'

# The user the applications run as.
USER = "admin"
USER_HOME_PATH = File.expand_path("~#{USER}")
RVM_PATH = USER_HOME_PATH + "/.rvm/"

# The place where all your applications reside. This scripts assumes that
# you have the following structure in your APPLICATIONS_PATH:
# APPLICATIONS_PATH
# |- APPLICATION_NAME
#    |- STAGE
#        |- server.yml (REQUIRED)
#        |- current     
APPLICATIONS_PATH = USER_HOME_PATH + "/applications/"

# Example :Server.yml
#
# passenger:
#   port: 10001 # The port number passenger standalone will be ran on
# rvm:
#   rvm_ruby_string: "rubyversion@gemsetname" # The ruby version and gemset RVM will use
# callbacks: # All callbacks are optional and are references to scripts relative to APPLICATIONS_PATH/APPLICATION_NAME/STAGE
#   start:
#     before: # Ran before passenger has started
#     after:  # Ran after passenger has started 
#   stop:
#     before: # Ran before passenger has been stopped
#     after:  # Ran after passenger has been stopped

# ======================================================
# Shouldn't be necessary to change stuff below this line
# ======================================================

# Main start routine.
def run!
  command = ARGV.first
  available_commands = %w{start stop list}
  raise "Use one of #{available_commands.join("|")} as first argument" unless available_commands.include?(command)

  applications = Dir.glob("#{APPLICATIONS_PATH}*/*").inject({}){|mem, dir| parts = dir.split("/"); mem[parts[-2]] ||= []; mem[parts[-2]] << parts[-1]; mem}

  if command == "list"
    str = "All applications for #{USER}"
    puts str
    puts "=" * str.size
    
    applications.each do |application, stages|
      puts "#{application} (#{APPLICATIONS_PATH}/#{application})"
      stages.each do |stage|
        puts "    - #{stage}"
      end
    end
  else
    if application = ARGV[1]
      unless applications.has_key?(application)
        raise "Can't find application #{application}"
      end

      if stage = ARGV[2]
        unless applications[application].include?(stage)
          raise "Stage #{stage} not found for application #{application}"
        end
        Application.new(application,stage).start_or_stop!(command)
      else
        applications[application].each do |stage|
          Application.new(application,stage).start_or_stop!(command)
        end
      end
    else
      applications.each do |application, stages|
        stages.each do |stage|
          Application.new(application,stage).start_or_stop!(command)
        end
      end
    end
  end
  true
end

# Wrapper class to handle application specific start and stop methods
# including callbacks
class Application
  
  attr_reader :config, :path, :name, :stage
  
  def initialize(application_name,stage)
    @path = Pathname.new("#{APPLICATIONS_PATH}#{application_name}/#{stage}")
    @name = application_name
    @stage = start_or_stop
    
    # Sanity check!
    raise "No server.yml found in '#{@path}'" unless File.exist?(@path +"server.yml")
    
    # Load config
    @config = YAML.load(File.read((@path +"server.yml").to_s))
  end
  
  def start_or_stop!(command)
    case command
    when "start" then self.start!
    when "stop"  then self.stop!
    end    
  end
  
  def start!
    say "Start #{USER} #{self.name} #{self.stage}"
    
    # Check for passenger gem.
    unless rvm_execute(self.config, "gem list passenger") =~ /passenger/
      say "Installing Passenger..."
      rvm_execute(self.config, "gem install passenger")
    end
    
    # Run the before start callback
    run_callback(:start, :before)
    
    # Start the server
    puts rvm_execute(self.config, "passenger start #{self.path + "current"} --user #{user} --port #{server_config['passenger']['port']} --environment production -d --pid-file #{self.path + "passenger.pid"}")
    
    # Run the after start callback
    run_callback(:start, :after)    
  end
  
  def stop!
    say "Stop #{USER} #{self.name} #{self.stage}"
    
    # Run the before :stop callback
    run_callback(:stop, :before)
    
    puts rvm_execute(self.config, "passenger stop --pid-file #{self.path + "passenger.pid"}")
    
    # Run the after :stop callback
    run_callback(:stop, :after)    
  end
  
  # Simple output wrapper
  def say(msg)
    puts msg
  end
  
  protected
  
  def callback(key, time)
    return unless self.config.has_key?("callbacks")
    
    callbacks = self.config["callbacks"]
    
    if callback = (callbacks[key.to_s] && callbacks[key.to_s][time.to_s])
      if File.exists?(self.path + callback)
        say "Running #{time} #{key} callback '#{callback}'"
        say rvm_execute(self.config, "bash #{self.path + callback}")
      else
        raise "Defined callback #{time} #{key} '#{callback}' does not exist!"
      end      
    end
  end
  
end

# Helper method to run within an RVM environment
def rvm_execute(server_config, command)
  execute("rvm_path=#{RVM_PATH} #{RVM_PATH}bin/rvm-shell '#{server_config['rvm']['rvm_ruby_string']}' -c '#{command}'")
end

# Execute command and decide wether or not to SUDO
def execute(command)
  whoami = `whoami`.strip
  if whoami == USER
    `#{command} 2>&1`
  else
    `sudo -u #{USER} -H #{command} 2>&1`
  end
end

begin
  if run!
    puts "Done!"
  else
    puts "Usage: passenger-standalone {start|stop|list} [application] [stage]"
  end
rescue StandardError => e
  puts "ERROR: #{e.message}"
  puts "Usage: passenger-standalone {start|stop|list} [application] [stage]"
end