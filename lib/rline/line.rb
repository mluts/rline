require 'rline/application'
require 'rline/input_token'
require 'rline/output_token'
require 'rline/terminal'
require 'rline/screen'

module RLine
  class Line
    def initialize(prompt = '> ')
      @term = RLine::Terminal.new
      @screen = RLine::Screen.new($stdin.winsize[1], prompt.length)
      @app = RLine::Application.new(@screen, prompt)
    end

    def gets
      @term.apply_token(@app.call(nil))

      loop do
        input_token = @term.next_token

        output_token = @app.call(input_token) unless input_token.nil?

        @term.apply_token(output_token) unless output_token.nil?

        break if output_token.is_a?(Exit)
      end

      @app.line
    end
  end
end
