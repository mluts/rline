module RLine
  class VT100
    def initialize(io = $stdout)
      @io = io
    end

    # @param token [RLine::OutputToken]
    def apply(token)
      case token
      when Print
        @io.print(token.value)
      when DeleteLeft
        @io.print(left % 1, dch % 1)
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

    def dch
      @dch ||= `tput dch 0`.sub('0', '%s')
    end
  end
end
