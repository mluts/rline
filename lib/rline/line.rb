require 'rline/utils'
require 'rline/cursor'

module RLine
  class Line
    include RLine::Utils

    attr_reader :text, :cursor

    def initialize(width)
      @width = width
      @text = ''
      @cursor = Cursor.new(width)
    end

    def insert(text)
      @text = [
        @text[0...@cursor.position],
        text,
        @text[@cursor.position..-1]
      ].join

      @cursor.move(text.length)

      if @cursor.position < @text.length
        redraw(@text, @cursor.position, @width)
      else
        Print.new(text)
      end
    end

    def move_cursor(n)
      if @cursor.position + n > @text.length
        @cursor.move(@text.length - @cursor.position)
      elsif @cursor.position + n < 0
        @cursor.move(-@cursor.position)
      else
        @cursor.move(n)
      end
    end

    def reset(width)
      @width = width
      @cursor.reset(width)
    end

    def wrapped?
      @text.length > @width
    end

    def lines
      @text.length / @width
    end

    def length
      @text.length
    end

    private

    def redraw(text, position, width)
      tokens = [ClearToEnd.new]
      parts = break_text(text, position, width)

      parts.each do |part|
        tokens.push(
          Print.new(part),
          CursorDown.new(1),
          CarriageReturn.new
        )
      end

      tokens.push(
        CursorUp.new(parts.count),
        CarriageReturn.new,
        CursorRight.new(column(position, width))
      )

      OutputSequence.new(tokens)
    end
  end
end
