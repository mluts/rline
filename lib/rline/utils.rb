module RLine
  module Utils
    module_function

    def break_text(text, position, screen_width)
      result = []
      breakpoints = [position]

      breakpoints << (1 + position / screen_width) * screen_width

      if breakpoints.last < text.length
        (breakpoints.last + screen_width).step(by: screen_width) do |breakpoint|
          breakpoints << breakpoint
          break if breakpoint >= text.length
        end
      end

      breakpoints.each_with_index do |point1, index|
        if (point2 = breakpoints[index+1]).nil?
          break
        else
          result << text[point1...point2]
        end
      end

      result
    end

    def column(position, screen_width)
      position % screen_width
    end

    def row(position, screen_width)
      position / screen_width
    end
  end
end
