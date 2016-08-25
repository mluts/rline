module RLine
  class AbstractTerminal
    # @return [RLine::InputToken]
    def next_token
    end

    # @return [RLine::OutputToken]
    def apply(output_token)
    end
  end
end
