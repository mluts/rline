module RLine
  class Screen
    attr_reader :line, :cursor

    def initialize(columns, left_bound = 0)
      @line = ''
      @cursor = 0
      @columns = columns
      @left_bound = left_bound
    end

    def print_char(char)
      if insert?
        insert(char)
      else
        append(char)
      end
    end

    def left
      if @cursor > @left_bound
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

      to_redraw = @line[@cursor..-1]

      to_redraw.chars.each do |c|
        tokens << append(c, true)
      end

      tokens << Kill.new

      to_redraw.length.times do
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

    def append(char, screen_only = false)
      unless screen_only
        @line << char
      end

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
        right_part = @line[@cursor..-1]
      ].join

      tokens = []

      tokens << append(char, true)

      right_part.chars.map do |c|
        tokens << append(c, true)
      end

      right_part.length.times do
        tokens << left
      end

      tokens
    end
  end
end
