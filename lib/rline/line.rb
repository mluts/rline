module RLine
  class Line
    class Cursor
      attr_reader :position

      def initialize(screen_width)
        @position = 0
        @screen_width = screen_width
      end

      def move(n)
        if @position + n < 0
          @position = 0
        else
          @position += n
        end
      end

      def col
        @position % @screen_width
      end

      def row
        @position / @screen_width
      end

      def reset(width)
        @width = width
      end
    end

    attr_reader :text, :cursor

    def initialize(width)
      @width = width
      @text = ''
      @cursor = Cursor.new(width)
    end

    def push(text)
      @text << text
      @cursor.move(text.length)
    end

    def reset(width)
      @width = width
      @cursor.reset(width)
    end

    def wrapped?
      @text.length > @width
    end
  end
end
