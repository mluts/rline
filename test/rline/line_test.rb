require 'test_helper'

class RLine::LineTest < TestCase
  def subject
    @subject ||= RLine::Line.new
  end

  def test_eof
    assert_nil subject.gets
  end

  def test_simple_text
    text = 'abcdefg'

    subject.term.input_tokens.push(
      *text.chars.map { |c| RLine::Character.new(c) },
      RLine::Enter.new
    )

    assert_equal text, subject.gets
  end
end
