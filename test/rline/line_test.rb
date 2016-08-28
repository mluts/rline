require 'test_helper'
require 'rline/line'

class RLine::LineTest < TestCase
  class CursorTest < TestCase
    def subject
      @subject ||= RLine::Line::Cursor.new(10)
    end

    def test_move
      assert_equal 0, subject.position
      assert_equal 0, subject.col
      assert_equal 0, subject.row

      subject.move(5)
      assert_equal 5, subject.position
      assert_equal 5, subject.col
      assert_equal 0, subject.row

      subject.move(5)
      assert_equal 10, subject.position
      assert_equal 0, subject.col
      assert_equal 1, subject.row

      subject.move(9)
      assert_equal 19, subject.position
      assert_equal 9, subject.col
      assert_equal 1, subject.row

      subject.move(-10)
      assert_equal 9, subject.position
      assert_equal 9, subject.col
      assert_equal 0, subject.row
    end
  end

  def subject
    @subject ||= RLine::Line.new(width)
  end

  def width
    @width ||= 10
  end

  def test_push
    subject.push('abc')
    assert_equal 'abc', subject.text
    assert_equal 3, subject.cursor.position
  end
end
