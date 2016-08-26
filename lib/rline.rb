require 'io/console'
require 'rline/application'
require 'rline/input_token'
require 'rline/output_token'
require 'rline/terminal'

module RLine
  module_function

  def gets
    app = Application.new
    term = Terminal.new

    loop do
      input_token = term.next_token

      output_token = app.call(input_token) unless input_token.nil?

      term.apply_token(output_token) unless output_token.nil?

      break if output_token.is_a?(Exit)
    end

    app.input
  end
end
