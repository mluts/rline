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

  def test_left
    text = 'a' * width

    text.chars.each { |c| subject.print_char(c) }

    assert_equal text.length, subject.cursor
    subject.left
    assert_equal text.length - 1, subject.cursor
  end

  def test_left_impossible
    assert_equal 0, subject.cursor
    subject.left
    assert_equal 0, subject.cursor
  end

  def test_right
    text = 'a' * width
    text.chars.each { |c| subject.print_char(c) }
    100.times { subject.left }
    assert_equal 0, subject.cursor
    subject.right
    assert_equal 1, subject.cursor
  end

  def test_right_impossible
    text = 'a' * width
    text.chars.each { |c| subject.print_char(c) }
    100.times { subject.left }
    assert_equal 0, subject.cursor
    100.times { subject.right }
    assert_equal text.length, subject.cursor
  end

  def test_right_wrap
    text = 'a' * (width * 2)
    text.chars.each { |c| subject.print_char(c) }
    100.times { subject.left }

    count = width * 1.5

    tokens = Array.new(count).map { subject.right }

    expected_tokens = [
      *Array.new(width - 1).map { RLine::MoveRight.new },
      RLine::WrapLine.new,
      *Array.new(count - width).map { RLine::MoveRight.new }
    ]

    assert_equal expected_tokens, tokens
  end

  def test_left_wrap
    text = 'a' * (width * 2)

    text.chars.each { |c| subject.print_char(c) }

    tokens = Array.new(text.length).map do
      subject.left
    end

    expected_tokens = [
      RLine::UnwrapLine.new(width),
      *Array.new(width - 1).map { RLine::MoveLeft.new },
      RLine::UnwrapLine.new(width),
      *Array.new(width - 1).map { RLine::MoveLeft.new }
    ]

    assert_equal expected_tokens, tokens
  end

  def test_print_inside_text
    text = 'asdasd'

    text.chars.each { |c| subject.print_char(c) }
    3.times { subject.left }

    token = subject.print_char('f')

    expected_token = [
      RLine::Print.new('f'),
      RLine::Print.new('a'),
      RLine::Print.new('s'),
      RLine::Print.new('d'),
      *Array.new(3).map { RLine::MoveLeft.new }
    ]

    assert_equal expected_token, token
  end

  def test_kill
    text = 'asdasd'
    text.chars.each { |c| subject.print_char(c) }
    3.times { subject.left }

    assert_equal RLine::Kill.new, subject.kill
    assert_equal 'asdsd', subject.line
    assert_equal 3, subject.cursor

    assert_equal RLine::Kill.new, subject.kill
    assert_equal 'asdd', subject.line
    assert_equal 3, subject.cursor

    assert_equal RLine::Kill.new, subject.kill
    assert_equal 'asd', subject.line
    assert_equal 3, subject.cursor

    assert_nil   subject.kill
    assert_equal 'asd', subject.line
    assert_equal 3, subject.cursor
  end

  def test_kill_wrap
    text = 'abcde12345abc'
    text.chars.each { |c| subject.print_char(c) }
    100.times { subject.left }
    5.times { subject.right }

    tokens = subject.kill

    expected_tokens = [
      RLine::Kill.new,
      RLine::Print.new('2'),
      RLine::Print.new('3'),
      RLine::Print.new('4'),
      RLine::Print.new('5'),
      [RLine::Print.new('a'), RLine::WrapLine.new],
      RLine::Print.new('b'),
      RLine::Print.new('c'),
      RLine::Kill.new,
      RLine::MoveLeft.new,
      RLine::MoveLeft.new,
      RLine::UnwrapLine.new(width),
      RLine::MoveLeft.new,
      RLine::MoveLeft.new,
      RLine::MoveLeft.new,
      RLine::MoveLeft.new
    ]

    assert_equal expected_tokens, tokens
  end

  def test_prompt
    prompt = '> '
    subject = RLine::Screen.new(width, prompt)

    assert_equal 0, subject.cursor

    subject.print_char('a')
    assert_equal 1, subject.cursor

    subject.print_char('a')
    assert_equal 2, subject.cursor

    subject.print_char('a')
    assert_equal 3, subject.cursor

    10.times { subject.left }
    assert_equal prompt.size, subject.cursor
  end

  def test_reset_columns
    n = width * 2
    text = 'a' * width
    text.chars.each { |c| subject.print_char(c) }

    3.times { subject.left }
    cursor = subject.cursor
    tokens = subject.reset_columns(n)

    expected_tokens = [
      *Array.new(subject.cursor, RLine::MoveLeft.new),
      RLine::ClearToEndOfScreen.new,
      *Array.new(text.length, RLine::Print.new('a')),
      *Array.new(text.length - cursor, RLine::MoveLeft.new)
    ]

    assert_equal expected_tokens, tokens
  end

  def test_kill_line
    text = 'a' * width

    text.chars.each { |c| subject.print_char(c) }
    tokens = subject.kill_line

    expected_tokens = [
      RLine::UnwrapLine.new(width),
      *Array.new(width - 1, RLine::MoveLeft.new),
      RLine::ClearToEndOfScreen.new
    ]

    assert_equal 0, subject.cursor
    assert_equal '', subject.line
    assert_equal expected_tokens, tokens
  end

  def test_reset_line_without_arguments
    prompt = '> '
    subject = RLine::Screen.new(width, prompt)

    tokens = subject.reset_line('')

    expected_tokens = [
      RLine::ClearToEndOfScreen.new,
      RLine::Print.new('>'),
      RLine::Print.new(' '),
    ]

    assert_equal expected_tokens, tokens
  end
end
