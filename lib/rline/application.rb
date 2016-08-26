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
          DeleteLeft.new
        end
      when Enter      then Exit.new
      when ArrowLeft
        if @position > 0
          @position -= 1
          Move.new(-1)
        end
      when ArrowRight then Move.new(1)
      end
    end
  end
end
