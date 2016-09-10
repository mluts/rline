module RLine
  class Screen
    attr_reader :line, :cursor

    def initialize(columns)
      @line = ''
      @cursor = 0
      @columns = columns
    end

    def print_char(char)
      if insert?
        insert(char)
      else
        append(char)
      end
    end

    def left
      if @cursor > 0
        @cursor -= 1

        if beyond_left?
          UnwrapLine.new
        else
          MoveLeft.new
        end
      end
    end

    def right
      if @cursor < @line.length
        @cursor += 1

        if beyond_right?
          WrapLine.new
        else
          MoveRight.new
        end
      end
    end

    def kill
      unless @line[@cursor].nil?
        @line.slice!(@cursor, 1)

        if @line.length + 1 < @columns
          Kill.new
        else
          redraw_kill
        end
      end
    end

    private

    def redraw_kill
      tokens = []

      tokens << Kill.new

      @line[@cursor..-1].chars.each do |c|
        tokens << append(c)
      end

      tokens << Kill.new

      (@line.length - @cursor).times do
        tokens << left
      end

      tokens
    end

    def beyond_right?
      (@cursor % @columns).zero?
    end

    def beyond_left?
      ((@cursor + 1) % @columns).zero?
    end

    def insert?
      @cursor < @line.length
    end

    def append(char)
      @line << char
      @cursor += 1

      if beyond_right?
        [Print.new(char), WrapLine.new]
      else
        Print.new(char)
      end
    end

    def insert(char)
      @line = [
        @line[0...@cursor],
        char,
        @line[@cursor..-1]
      ].join

      @cursor += 1

      tokens = []

      @line[(@cursor - 1)..-1].chars.map do |c|
        tokens << append(c)
      end

      (@line.length - @cursor).times do
        tokens << left
      end

      tokens
    end
  end
end
