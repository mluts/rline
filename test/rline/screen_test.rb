require 'test_helper'
require 'rline/screen'

class RLine::ScreenTest < TestCase
  def subject
    @subject ||= RLine::Screen.new(width)
  end

  def width
    @width ||= 10
  end

  def test_print_char
    assert_equal 0, subject.cursor

    token = subject.print_char('a')

    assert_equal RLine::Print.new('a'), token
    assert_equal 'a', subject.line
    assert_equal 1, subject.cursor
  end

  def test_multiple_chars
    text = 'asdasd'

    text.chars.each do |char|
      subject.print_char(char)
    end

    assert_equal text.length, subject.cursor
    assert_equal text, subject.line
  end
end
