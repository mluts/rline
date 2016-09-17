class FakeTerm
  attr_reader :input_tokens, :output_tokens

  def initialize
    @input_tokens = []
    @output_tokens = []
  end

  def next_token
    if input_tokens.empty?
      RLine::EOF.new
    else
      input_tokens.shift
    end
  end

  def apply_token(token)
    output_tokens << token
  end
end
