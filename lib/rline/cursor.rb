require 'rline/utils'

module RLine
  class Cursor
    include RLine::Utils

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
      column @position, @screen_width
    end

    def row
      super @position, @screen_width
    end

    def reset(width)
      @screen_width = width
    end
  end
end
