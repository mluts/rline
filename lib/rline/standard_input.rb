require 'io/console'
require 'rline/escape_sequence'

module RLine
  class StandardInput
    BACKSPACE = "\u007F".freeze
    ENTER     = "\r".freeze

    def initialize(io = $stdin)
      @io = io
    end

    def next
      @io.raw do
        translate(@io.getc)
      end
    end

    def translate(char)
      case char
      when BACKSPACE
        Backspace.new
      when ENTER
        Enter.new
      when "\e"
        escape_sequence = read_escape_sequence
        token_for(escape_sequence.string)
      else
        Character.new(char)
      end
    end

    def token_for(string)
      case string
      when "\e[A" then RLine::ArrowUp.new
      when "\e[B" then RLine::ArrowDown.new
      when "\e[C" then RLine::ArrowRight.new
      when "\e[D" then RLine::ArrowLeft.new
      end
    end

    private

    def read_escape_sequence
      escape_sequence = EscapeSequence.new
      while !escape_sequence.complete?
        escape_sequence.push(@io.getc)
      end
      escape_sequence
    end
  end
end
