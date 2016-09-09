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
  DeleteLeft  = Class.new(OutputToken)
  DeleteRight = Class.new(OutputToken)
  Move        = Class.new(OutputToken)
  Exit        = Class.new(OutputToken)
  DeleteLine  = Class.new(OutputToken)
  Reset       = Class.new(OutputToken)

  MoveHorizontal  = Class.new(OutputToken)
  MoveVertical    = Class.new(OutputToken)
  WrapLine        = Class.new(OutputToken)
end
