class RLine
  class Terminal
    attr_reader :cap

    def initialize(output, terminfo)
      @output = output
      @cap = terminfo
    end

    def newline
      @output.print cap.lf
    end

    def reset_line
      @output.print cap.cr,
                    cap.el,
                    cap.sgr0
    end

    def print(*args)
      @output.print(*args)
    end
  end
end
