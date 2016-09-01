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
  OutputSequence    = Class.new(OutputToken)
  Newline           = Class.new(OutputToken)

  CursorDown      = Class.new(OutputToken)
  CursorUp        = Class.new(OutputToken)
  CursorRight     = Class.new(OutputToken)
  CursorLeft      = Class.new(OutputToken)
  ClearToEnd      = Class.new(OutputToken)
  CarriageReturn  = Class.new(OutputToken)

  ReplaceAt       = Class.new(OutputToken)
end
