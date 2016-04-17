require 'io/console'
require 'rline/terminfo'
require 'rline/terminal'

class RLine

  attr_reader :line, :terminal, :terminfo

  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
    @line = String.new
    @terminfo = Terminfo.new
    @terminal = Terminal.new(@output, @terminfo)
  end

  def readline(prompt)
    raise "#{@input.inspect} is not a TTY" unless @input.tty?

    @prompt = prompt

    line.clear

    eof_met = false

    render

    while (c = @input.getch) != terminfo.cr do
      if c == terminfo.eof
        eof_met = true
        break
      else
        handle(c)
      end
    end

    terminal.newline

    if eof_met && line.empty?
      nil
    else
      line.dup
    end
  end

  def handle(c)
    line << c
    render
  end

  def render
    terminal.reset_line
    terminal.print @prompt, line
  end
end
