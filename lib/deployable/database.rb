# = Database.yml related tasks
#
# == Usage
# 
# * Include this file in your <tt>deploy.rb</tt> configuration file.
# * Setup the required variables (see below)
# * After deploy:setup run database:setup
# * After deploy:update_code run database:copy_config_to_release
#
# == Setting variables
# 
# The recipe uses the variable :database_config. You can put in there whatever you like but these are the defaults:
#
#  set :database_config, {
#        :username => "", 
#        :host => "",
#        :development => "", 
#        :production => "",
#        :test => ""
#  }
#
# == Password
# 
# Because you definitely don't want the password for the database in your SCM the recipe
# asks you for it.
# 
# == Custom template
# 
# By default, this script creates the database.yml below. 
#
# If you want to overwrite the default template, simply create a custom Erb template
# called <tt>database.yml.erb</tt> and save it into <tt>config/deploy</tt> folder.
# 
# Although the name of the file can't be changed, you can customize the directory
# where it is stored defining a variable called <tt>:template_dir</tt>.
# 
#   # store your custom template at foo/bar/database.yml.erb
#   set :template_dir, "foo/bar"
# 
#   # example of database template
#   
#   # MySQL (default setup).  Versions 4.1 and 5.0 are recommended.
#   
#   db: &db
#     adapter: mysql2
#     username: <%= db[:username] %>
#     password: <%= db[:password] %>
#     host: <%= db[:host] %>
#   
#   development:
#     <<: *db
#     database: <%= db[:development] %>
#   
#   test:
#     <<: *db
#     database: <%= db[:test] %>
#   
#   production:
#     <<: *db
#     database: <%= db[:production] %>
# 
#
# Because this is an Erb template, you can place variables and Ruby scripts
# within the file.
# For instance, the template above takes advantage of Capistrano CLI
# to ask for a MySQL database password instead of hard coding it into the template.
Capistrano::Configuration.instance.load do
  namespace :database do
    desc <<-DESC
      Creates the database.yml configuration file in deploy path.
      It asks for a database password.

      By default, this task uses a template unless a template \
      called database.yml.erb is found either is :template_dir \
      or /config/deploy folders. The default template matches \
      the template for config/database.yml file shipped with Rails.

    DESC
    task :setup, :except => { :no_release => true } do

      default_template = <<-EOF
# MySQL (default setup).  Versions 4.1 and 5.0 are recommended.

db: &db
  adapter: mysql2
  username: <%= config[:username] %>
  password: <%= Capistrano::CLI.ui.ask "Database password: " %>
  host: <%= config[:host] %>

development:
  <<: *db
  database: <%= config[:development] %>

test:
  <<: *db
  database: <%= config[:test] %>

production:
  <<: *db
  database: <%= config[:production] %>
EOF

      location = fetch(:template_dir, "config/deploy") + '/database.yml.erb'
      template = File.file?(location) ? File.read(location) : default_template

      config = ERB.new(template)

      put config.result(OpenStruct.new(:config => :database_config).send(:binding)), "#{deploy_to}/database.yml"
    end

    desc <<-DESC
      Copies the setup database.yml to the just deployed release.
    DESC
    task :copy_config_to_release, :except => { :no_release => true } do
      run "cp #{deploy_to}/database.yml #{release_path}/config/database.yml"
    end

  end
end