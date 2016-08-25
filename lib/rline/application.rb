module RLine
  class Application
    def initialize
    end

    # @param token [RLine::InputToken]
    # @return [RLine::OutputToken]
    def call(token)
      case token
      when Character
        Print.new(token.value)
      end
    end
  end
end
