# frozen_string_literal: true

require 'io/console'
require 'rline/escape_sequence'

module RLine
  class StandardInput
    BACKSPACE = "\u007F"
    ENTER     = "\r"
    EOT       = "\u0004"
    ESCAPE    = "\e"
    TAB       = "\t"
    CONTROL_CHARACTER = "\u0000".."\u001F"

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
        Backspace.new(char)
      when TAB
        Tab.new(char)
      when ENTER
        Enter.new(char)
      when EOT
        EOF.new
      when ESCAPE
        escape_sequence = read_escape_sequence
        token_for(escape_sequence.string)
      when CONTROL_CHARACTER
        ControlCharacter.new(char)
      else
        Character.new(char)
      end
    end

    def token_for(string)
      case string
      when "\e[A"   then RLine::ArrowUp.new
      when "\e[B"   then RLine::ArrowDown.new
      when "\e[C"   then RLine::ArrowRight.new
      when "\e[D"   then RLine::ArrowLeft.new
      when "\e[3~"  then RLine::Delete.new
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
