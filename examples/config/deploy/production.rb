# Servers
role :app, "APPSERVER", :primary => true  
role :db, "DBSERVER", :primary => true  

# RVM configuration
set :rvm_ruby_string, "RUBYVERSION@#{application}-#{stage}"
set :rvm_type, :user

# Deploy location / code
set :deploy_to, "DEPLOYLOCATION/#{application}/#{stage}"
set :branch, "master"

# Passenger config
set :passenger_standalone, {
  :passenger => {
    :port => 10001
  }
} 

# Database config
set :database_config, {
  :adapter => "mysql",
  :username => "", 
  :host => "",
  :development => "", 
  :test => "",
  :production => ""
}

# Bundle configuration (is optional)
set :bundle_config, {
  :build => {
    :mysql => "--with-mysql-config='/usr/bin/mysql_config'"
  }
}
