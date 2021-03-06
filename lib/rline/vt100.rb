require 'io/console'

module RLine
  class VT100
    def initialize(io = $stdout)
      @io = io
    end

    # @param token [RLine::OutputToken]
    def apply(token)
      case token
      when Array
        token.each(&method(:apply))
      when Print
        @io.print(token.value)
      when MoveRight
        @io.print(right % 1)
      when MoveLeft
        @io.print(left % 1)
      when WrapLine
        @io.print("\r\n")
      when UnwrapLine
        @io.print(up % 1, "\r", right % (token.value - 1))
      when Kill
        @io.print(dch % 1)
      when Exit
        @io.print "\r\n"
      when ClearToEndOfScreen
        @io.print ed
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

    def ed
      @ed ||= `tput ed`
    end
  end
end
