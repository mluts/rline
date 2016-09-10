require 'io/console'
require 'rline/application'
require 'rline/input_token'
require 'rline/output_token'
require 'rline/terminal'

module RLine
  class Line
    def initialize(prompt = '> ')
      @app = RLine::Application.new
      @term = RLine::Terminal.new
      @prompt = prompt
    end

    def gets
      should_reset = false
      trap(:SIGWINCH) { should_reset = true }

      @prompt.chars.each do |c|
        @term.apply_token @app.call(Character.new(c))
      end

      loop do
        input_token = @term.next_token

        output_token = @app.call(input_token) unless input_token.nil?

        @term.apply_token(output_token) unless output_token.nil?

        break if output_token.is_a?(Exit)

        if should_reset
          should_reset = false
          reset
        end
      end

      @app.screen.line
    end

    def reset
      # @term.apply_token(Reset.new)
      # @term.apply_token(Print.new(@prompt))
      # @term.apply_token(Print.new(@app.input))
    end
  end

  module_function

  def gets(prompt = '> ')
    Line.new(prompt).gets
  end
end
