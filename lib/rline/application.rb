require 'io/console'
require 'rline/mapping/emacs'
require 'rline/history'

module RLine
  class Application
    attr_reader :input, :screen

    class << self
      def actual_screen_width
        $stdin.winsize[1]
      end
    end

    def initialize(screen, prompt)
      @screen = screen
      @prompt = prompt
      @history = History

      @should_print_prompt = true
      @should_reset = false
      trap(:SIGWINCH) { @should_reset = true }
    end

    def call(token)
      tokens = pending_tokens

      case token
      when Exit
        @history.push(line) unless line.empty?
      end

      if tokens.any?
        [*tokens, *token]
      else
        token
      end
    end

    private

    def line
      @screen.line[@prompt.size..-1]
    end

    def reset
      @should_reset = false
      @screen.reset_columns(self.class.actual_screen_width)
    end

    def print_prompt
      @should_print_prompt = false
      @screen.reset_line(line)
    end

    def pending_tokens
      tokens = []
      tokens.concat(Array(reset)) if @should_reset
      tokens.concat(Array(print_prompt)) if @should_print_prompt
      tokens
    end
  end
end
