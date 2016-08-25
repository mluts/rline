module RLine
  class InputToken
    attr_reader :value

    def initialize(value = nil)
      @value = value
    end
  end

  Character   = Class.new(InputToken)
  Backspace   = Class.new(InputToken)
  ArrowLeft   = Class.new(InputToken)
  ArrowRight  = Class.new(InputToken)
end
