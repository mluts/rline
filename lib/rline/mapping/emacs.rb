module RLine
  module Mapping
    module Emacs
      module_function

      def call(token, screen)
        case token
        when Character
          screen.print_char(token.value)
        when Backspace
          [
            *screen.left,
            *screen.kill
          ]
        when Enter, EOF
          Exit.new
        when ArrowLeft
          screen.left
        when ArrowRight
          screen.right
        when Delete
          screen.kill
        when ControlCharacter
          case token.char
          when 'u'
            if screen.cursor > 0
              token = []
              screen.cursor.times do
                token << screen.left
                token << screen.kill
              end
              token
            end
          end
        end
      end
    end
  end
end
