require "deployable/version"
require 'pathname'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

module Deployable
end
