require 'rline/line'

module RLine
  module_function

  def gets(*args)
    Line.new(*args).gets
  end
end
