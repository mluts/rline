require 'io/console'

module RLine
  class VT100
    def initialize(io = $stdout, cols = io.winsize[1])
      @io = io
      @position = 0
      @row = 0
      @cols = cols
      apply DeleteLine.new
    end

    # @param token [RLine::OutputToken]
    def apply(token)
      case token
      when Print
        token.value.chars.each do |char|
          @position += 1
          @io.print(char)

          if @position == @cols
            @io.print("\r\n")
            @position = 0
            @row += 1
          end
        end
      when Reset
        @cols = @io.winsize[1]

        @row.times do
          apply DeleteLine.new
          @io.print(up % 1)
        end

        @row = 0
        @position = 0

        apply DeleteLine.new
      when DeleteLine
        @io.print("\r", dch % @cols)
      when DeleteLeft
        limit = @position + @row * @cols
        length = token.value
        length = limit if length > limit
        length.times do
          if @position == 0 && @row > 0
            @io.print(up % 1, "\r", right % @cols, dch % 1)
            @row -= 1
            @position = @cols - 1
          else
            @position -= 1
            @io.print(left % 1, dch % 1)
          end
        end
      when Move
        if token.value < 0
          @io.print(left % -token.value)
        elsif token.value > 0
          @io.print(right % token.value)
        end
      when Exit
        @io.print "\r\n"
      end
    end

    private

    def left
      @left ||= `tput cub 0`.sub('0', '%s')
    end

    def right
      @right ||= `tput cuf 0`.sub('0', '%s')
    end

    def up
      @up ||= `tput cuu 0`.sub('0', '%s')
    end

    def down
      @down ||= `tput cud 0`.sub('0', '%s')
    end

    def dch
      @dch ||= `tput dch 0`.sub('0', '%s')
    end

    def dl1
      @dl1 ||= `tput dl1`
    end
  end
end
