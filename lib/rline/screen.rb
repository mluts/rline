module RLine
  class Screen
    attr_reader :line, :cursor

    def initialize(columns)
      @line = ''
      @cursor = 0
      @columns = columns
    end

    def print_char(char)
      @line << char
      @cursor += 1
      Print.new(char)
    end
  end
end
