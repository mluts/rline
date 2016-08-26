require 'rline/vt100'
require 'rline/standard_input'

module RLine
  class Terminal
    def initialize
      @input = StandardInput.new
      @output = VT100.new
    end

    def next_token
      @input.next
    end

    def apply_token(output_token)
      @output.apply(output_token)
    end
  end
end
