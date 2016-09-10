require 'rline/application'
require 'rline/input_token'
require 'rline/output_token'
require 'rline/terminal'
require 'rline/screen'

module RLine
  class Line
    def initialize(prompt = '> ')
      @term = RLine::Terminal.new
      @screen = RLine::Screen.new($stdin.winsize[1])
      @app = RLine::Application.new(@screen)
      @prompt = prompt
    end

    def gets
      @prompt.chars.each do |c|
        @term.apply_token @app.call(Character.new(c))
      end

      loop do
        input_token = @term.next_token

        output_token = @app.call(input_token) unless input_token.nil?

        @term.apply_token(output_token) unless output_token.nil?

        break if output_token.is_a?(Exit)
      end

      @app.screen.line[@prompt.length..-1]
    end
  end
end
