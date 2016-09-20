module RLine
  class Screen
    attr_reader :line, :cursor

    def initialize(columns, prompt = '')
      @line = ''
      @cursor = 0
      @columns = columns
      @prompt = prompt
      @left_bound = prompt.size
    end

    def print_char(char)
      if insert?
        insert(char)
      else
        append(char)
      end
    end

    def left(left_bound = @left_bound)
      if @cursor > left_bound
        @cursor -= 1

        if beyond_left?
          UnwrapLine.new(@columns)
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

    def reset_columns(columns)
      tokens = []

      original_cursor = @cursor

      @cursor.times { tokens << left(0) }

      tokens << ClearToEndOfScreen.new

      @columns = columns

      @line.chars.each do |c|
        tokens << append(c, true)
      end

      (@cursor - original_cursor).times do
        tokens << left
      end

      tokens
    end

    def kill_line
      tokens = []
      @cursor.times { tokens << left(0) }
      @line.clear
      tokens << ClearToEndOfScreen.new
      tokens
    end

    def reset_line(new_line)
      tokens = []
      tokens.concat(kill_line)
      [
        *@prompt.chars,
        *new_line.to_s.chars
      ].each do |c|
        tokens << print_char(c)
      end
      tokens
    end

    def line_without_prompt
      @line[@prompt.size..-1].to_s
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
