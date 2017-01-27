require 'rline/application'
require 'rline/input_token'
require 'rline/output_token'
require 'rline/terminal'
require 'rline/screen'
require 'rline/middleware'
require 'rline/completion'

module RLine
  class Line
    class << self
      attr_accessor :term_class
    end

    self.term_class = ::RLine::Terminal

    attr_reader :term

    def initialize(prompt = '> ', completion_proc: proc{[]})
      @term = self.class.term_class.new
      @prompt = prompt
      @screen = RLine::Screen.new($stdin.winsize[1], prompt)
      @app = RLine::Middleware.new(
        RLine::Completion.new(@screen, completion_proc),
        RLine::Mapping::Emacs.new(@screen, RLine::History),
        RLine::Application.new(@screen, prompt)
      )
    end

    def gets
      @term.apply_token(@app.call(nil))

      final_token = _gets

      line = @screen.line_without_prompt

      if final_token.value.is_a?(EOF) && line.empty?
        nil
      else
        line
      end
    end

    private

    def _gets
      loop do
        input_token = @term.next_token

        output_token = @app.call(input_token) unless input_token.nil?

        @term.apply_token(output_token) unless output_token.nil?

        break output_token if output_token.is_a?(Exit)
      end
    end
  end
end
