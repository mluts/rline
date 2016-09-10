module RLine
  class OutputToken
    attr_reader :value

    def initialize(value = nil)
      @value = value
    end

    def ==(other)
      other.is_a?(self.class) && other.value == value
    end
  end

  Print       = Class.new(OutputToken)
  Exit        = Class.new(OutputToken)

  MoveRight   = Class.new(OutputToken)
  MoveLeft    = Class.new(OutputToken)
  MoveUp      = Class.new(OutputToken)
  MoveDown    = Class.new(OutputToken)
  WrapLine    = Class.new(OutputToken)
  UnwrapLine  = Class.new(OutputToken)
  Kill        = Class.new(OutputToken)
end
