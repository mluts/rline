module RLine
  module Mapping
    class Emacs
      def initialize(screen, history)
        @screen = screen
        @history = history
        @history_shift = 0
      end

      def call(token)
        case token
        when Character
          @screen.print_char(token.value)
        when Backspace
          [
            *@screen.left,
            *@screen.kill
          ]
        when Enter, EOF
          @history_shift = 0
          Exit.new(token)
        when ArrowLeft
          @screen.left
        when ArrowRight
          @screen.right
        when ArrowUp
          @screen.reset_line(back_in_history)
        when ArrowDown
          @screen.reset_line(forward_in_history)
        when Delete
          @screen.kill
        when ControlCharacter
          case token.char
          when 'u'
            if @screen.cursor > 0
              token = []
              @screen.cursor.times do
                token << @screen.left
                token << @screen.kill
              end
              token
            end
          end
        when Array, OutputToken
          token
        end
      end

      def back_in_history
        @history_shift += 1
        @history_shift = @history.count if @history_shift > @history.count
        @history[@history.count - @history_shift].to_s
      end

      def forward_in_history
        @history_shift -= 1
        @history_shift = 0 if @history_shift < 0
        @history[@history.count - @history_shift].to_s
      end
    end
  end
end
