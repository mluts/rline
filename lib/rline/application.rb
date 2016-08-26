module RLine
  class Application
    attr_reader :input

    def initialize
      @input = ''
    end

    # @param token [RLine::InputToken]
    # @return [RLine::OutputToken]
    def call(token)
      case token
      when Character
        @input << token.value
        Print.new(token.value)
      when Backspace
        @input.slice!(0, @input.length-1)
        DeleteLeft.new
      when Enter      then Exit.new
      when ArrowLeft  then Move.new(-1)
      when ArrowRight then Move.new(1)
      end
    end
  end
end
