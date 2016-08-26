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
        @io.print left1, del1
      when Exit
        @io.print "\r\n"
      end
    end

    private

    def left1
      @left1 ||= `tput cub1`
    end

    def del1
      @del1 ||= `tput dch1`
    end
  end
end
