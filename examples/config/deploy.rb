# ======================================
# = Base deploy script for application =
# ======================================
# Run with: bundle exec cap STAGE deploy
# ======================================

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# ======================================

set :stages, %w(production)
set :application, "APPLICATION NAME"
set :repository,  "git@reposerver:#{application}.git"
set :scm, "git"

set :deploy_via, :remote_cache
set :git_enable_submodules, 1

set :user, "admin"
set :use_sudo, false

set :config_files, {
  "local.rb" => defer{ "#{current_release}/config/local.rb" }
}

# ======================================

require 'deployable/recipes/default_with_database'
