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
      @mapping = RLine::Mapping::Emacs.new(screen, @history)

      @should_print_prompt = true
      @should_reset = true
      trap(:SIGWINCH) { @should_reset = true }
    end

    # @param token [RLine::InputToken]
    # @return [RLine::OutputToken]
    def call(token)
      pending_tokens = pending_tokens()
      response = @mapping.call(token)

      case response
      when Exit
        @history.push(line) unless line.empty?
      end

      if pending_tokens && pending_tokens.any?
        [*pending_tokens, *response]
      else
        response
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
      @prompt.chars.map { |c| @screen.print_char(c) }
    end

    def pending_tokens
      tokens = []
      tokens.concat(Array(reset)) if @should_reset
      tokens.concat(Array(print_prompt)) if @should_print_prompt
      tokens
    end
  end
end
