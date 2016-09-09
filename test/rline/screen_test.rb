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

  def test_print_wrapped
    text = 'a' * (width * 1.5).to_i

    tokens = text.chars.map { |c| subject.print_char(c) }

    expected_tokens = [
      *text[0...(width - 1)].chars.map { |c| RLine::Print.new(c) },
      [RLine::Print.new(text[width - 1]), RLine::WrapLine.new],
      *text[width..-1].chars.map { |c| RLine::Print.new(c) }
    ]

    assert_equal expected_tokens, tokens
  end

  def test_move_left
    text = 'a' * width

    text.chars.each { |c| subject.print_char(c) }

    assert_equal text.length, subject.cursor
    subject.move_left
    assert_equal text.length - 1, subject.cursor
  end

  def test_move_left_impossible
    assert_equal 0, subject.cursor
    subject.move_left
    assert_equal 0, subject.cursor
  end

  def test_move_right
    text = 'a' * width
    text.chars.each { |c| subject.print_char(c) }
    100.times { subject.move_left }
    assert_equal 0, subject.cursor
    subject.move_right
    assert_equal 1, subject.cursor
  end

  def test_move_right_impossible
    text = 'a' * width
    text.chars.each { |c| subject.print_char(c) }
    100.times { subject.move_left }
    assert_equal 0, subject.cursor
    100.times { subject.move_right }
    assert_equal text.length, subject.cursor
  end

  def test_move_right_wrap
    text = 'a' * (width * 2)
    text.chars.each { |c| subject.print_char(c) }
    100.times { subject.move_left }

    count = width * 1.5

    tokens = Array.new(count).map { subject.move_right }

    expected_tokens = [
      *Array.new(width - 1).map { RLine::MoveRight.new },
      RLine::WrapLine.new,
      *Array.new(count - width).map { RLine::MoveRight.new }
    ]

    assert_equal expected_tokens, tokens
  end
end
