require 'test_helper'
require 'rline/line'

class RLine::LineTest < TestCase

  def subject
    @subject ||= RLine::Line.new(width)
  end

  def width
    @width ||= 10
  end

  def test_insert
    subject.insert('abc')
    assert_equal 'abc', subject.text
    assert_equal 3, subject.cursor.position
  end

  def test_move_cursor
    subject.insert('abcdef')
    assert_equal 6, subject.cursor.position
    subject.move_cursor(-10)
    assert_equal 0, subject.cursor.position
    subject.move_cursor(10)
    assert_equal 6, subject.cursor.position
    subject.move_cursor(-2)
    assert_equal 4, subject.cursor.position
  end

  def test_insert_tokens
    assert_equal RLine::Print.new('abcdef'),
                 subject.insert('abcdef')

    subject.move_cursor(-2)
    assert_equal RLine::Print.new('[]ef'),
                 subject.insert('[]')
  end

  def test_insert_tokens_when_wrapped
    assert_equal RLine::OutputSequence.new([
      RLine::ClearToEnd.new,
      RLine::Print.new('abcdeabcde'),
      RLine::CursorDown.new(1),
      RLine::CarriageReturn,
      RLine::Print.new('abcde')
    ]), subject.insert('abcdeabcdeabcde')
  end
end
