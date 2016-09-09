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

      if beyond_right?
        [Print.new(char), RLine::WrapLine.new]
      else
        Print.new(char)
      end
    end

    def move_left
      if @cursor > 0
        @cursor -= 1

        if beyond_left?
          UnwrapLine.new
        else
          MoveLeft.new
        end
      end
    end

    def move_right
      if @cursor < @line.length
        @cursor += 1

        if beyond_right?
          WrapLine.new
        else
          MoveRight.new
        end
      end
    end

    private

    def beyond_right?
      (@cursor % @columns).zero?
    end

    def beyond_left?
      ((@cursor + 1) % @columns).zero?
    end
  end
end
