module RLine
  class EscapeSequence
    # @see http://www.ecma-international.org/publications/standards/Ecma-048.htm
    # @see http://www.ecma-international.org/publications/standards/Ecma-006.htm
    FINAL_BYTES = (64..126)

    attr_reader :string

    def initialize
      @string = "\e"
    end

    def push(character)
      @string << character
    end

    def complete?
      @string.size > 2 && FINAL_BYTES.include?(@string[-1].ord)
    end
  end
end
