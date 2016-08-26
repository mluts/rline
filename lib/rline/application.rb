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
      when Character  then Print.new(token.value)
      when Backspace  then DeleteLeft.new
      when ArrowLeft  then Move.new(-1)
      when ArrowRight then Move.new(1)
      end
    end
  end
end
