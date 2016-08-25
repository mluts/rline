module RLine
  class InputToken
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end
end

require 'rline/input_token/character'
