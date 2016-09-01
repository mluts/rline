require 'test_helper'
require 'rline/line/insert'

class RLine::Line::InsertTest < TestCase
  def subject
    RLine::Line::Insert.new(
      text, new_text, position, width
    )
  end

  def text
    @text ||= 'abcde12345abcde12345'
  end

  def new_text
    @new_text ||= 'abc'
  end

  def position
    @position ||= 7
  end

  def width
    @width ||= 10
  end

  def test_cursor_movement
    assert_equal new_text.length, subject.cursor_movement
  end

  def test_result_text
    assert_equal 'abcde12abc345abcde12345',
                 subject.resulting_text
  end

  def test_resulting_text2
    text.replace('')

    assert_equal new_text, subject.resulting_text
  end

  def test_output_token1
    @position = 0
    @text = ''
    @new_text = 'abc'

    assert_equal RLine::OutputSequence.new([
      RLine::Print.new('abc')
    ]), subject.output_token
  end

  def test_output_token2
    @position = 0
    @text = ''
    @new_text = 'abcdef12345abcde'

    assert_equal RLine::OutputSequence.new([
      RLine::Print.new('abcdef1234'),
      RLine::CursorDown.new(1),
      RLine::CarriageReturn.new,
      RLine::Print.new('5abcde')
    ]), subject.output_token
  end
end
