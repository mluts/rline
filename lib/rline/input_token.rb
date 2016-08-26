module RLine
  class InputToken
    attr_reader :value

    def initialize(value = nil)
      @value = value
    end

    def ==(other)
      other.is_a?(self.class) && other.value == value
    end
  end

  Character   = Class.new(InputToken)
  Backspace   = Class.new(InputToken)
  ArrowLeft   = Class.new(InputToken)
  ArrowRight  = Class.new(InputToken)
  ArrowUp     = Class.new(InputToken)
  ArrowDown   = Class.new(InputToken)
  Enter       = Class.new(InputToken)
  EOF         = Class.new(InputToken)
  ControlCharacter = Class.new(InputToken) do
    def char
      ("@".ord + value.ord).chr.downcase
    end
  end
  Delete = Class.new(InputToken)
end
