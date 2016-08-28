module RLine
  class Application
    attr_reader :input

    def initialize
      @position = 0
      @input = ''
    end

    # @param token [RLine::InputToken]
    # @return [RLine::OutputToken]
    def call(token)
      case token
      when Character
        @input << token.value
        @position += 1
        Print.new(token.value)
      when Backspace
        if @position > 0
          @position -= 1
          @input.slice!(@position, 1)
          DeleteLeft.new(1)
        end
      when Enter, EOF
        Exit.new
      when ArrowLeft
        if @position > 0
          @position -= 1
          Move.new(-1)
        end
      when ArrowRight
        if @position < @input.length
          @position += 1
          Move.new(1)
        end
      when Delete
        if @position < @input.length
          @input.slice!(@position, 1)
          DeleteRight.new(1)
        end
      when ControlCharacter
        case token.char
        when 'u'
          if @position > 0
            position = @position
            @position = 0

            @input.slice!(0, position)
            DeleteLeft.new(position)
          end
        end
      end
    end
  end
end
