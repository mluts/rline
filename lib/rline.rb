require 'rline/line'

module RLine
  module_function

  def gets(prompt = '> ')
    Line.new(prompt).gets
  end
end
