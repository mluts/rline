module RLine
  class OutputToken
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def ==(other)
      other.is_a?(self.class) && other.value == value
    end
  end
end

require 'rline/output_token/print'
