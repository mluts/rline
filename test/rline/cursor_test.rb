require 'test_helper'

class RLine::CursorTest < TestCase
  def subject
    @subject ||= RLine::Cursor.new(10)
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
