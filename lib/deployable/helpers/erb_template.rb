require 'erb'
require 'ostruct'

class Deployable::ErbTemplate
  def initialize(template)
    @template = ERB.new(template)
  end
  
  def render(variables)
    context = OpenStruct.new(:config => variables).instance_eval{ binding }
    view.result(context)
  end
end
