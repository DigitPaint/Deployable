require 'erb'
require 'ostruct'

module Deployable
  class ErbTemplate
    def initialize(template)
      @template = ERB.new(template)
    end
  
    def render(variables)
      context = OpenStruct.new(:config => variables).instance_eval{ binding }
      @template.result(context)
    end
  end
end