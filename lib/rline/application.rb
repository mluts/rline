require 'io/console'
require 'rline/screen'

module RLine
  class Application
    attr_reader :input, :screen

    def initialize
      @screen = Screen.new($stdin.winsize[1])
    end

    # @param token [RLine::InputToken]
    # @return [RLine::OutputToken]
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
        Exit.new
      when ArrowLeft
        @screen.left
      when ArrowRight
        @screen.right
      when Delete
        @screen.kill
      when ControlCharacter
        # case token.char
        # when 'u'
        #   if @position > 0
        #     position = @position
        #     @position = 0
        #
        #     @input.slice!(0, position)
        #     DeleteLeft.new(position)
        #   end
        # end
      end
    end
  end
end
