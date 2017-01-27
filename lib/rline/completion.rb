module RLine
  class Completion
    def initialize(screen, complete = proc{[]})
      @screen = screen
      @complete = complete
    end

    def call(token)
      if token.is_a?(Tab)
        complete(@screen.line_without_prompt)
      else
        token
      end
    end

    private

    def complete(line)
      options = @complete.call(line)

      if options.size == 1
        @screen.reset_line(options.first)
      elsif options.size > 1
        screen = RLine::Screen.new(@screen.columns, '')

        [
          @screen.kill_line,
          options.map do |option|
            option.chars.map { |c| screen.print_char(c) } +
              [screen.print_char(' ')]
          end,
          RLine::WrapLine.new,
          @screen.reset_line(line)
        ]
      end
    end
  end
end
