module RLine
  module History
    module_function

    def size=(val)
      @size = val
    end

    def size
      @size ||= 10
    end

    def count
      inputs.size
    end

    def [](index)
      inputs[index]
    end

    def push(input)
      inputs << input
      if count > size
        inputs.slice!(0, inputs.size - size)
      end
    end

    def inputs
      @inputs ||= []
    end
  end
end
