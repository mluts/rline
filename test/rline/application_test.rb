require 'test_helper'

class RLine::ApplicationTest < TestCase
  def subject
    @subject ||= RLine::Application.new(screen)
  end

  def screen
    @screen ||= Minitest::Mock.new
  end

  def ctrl_(char)
    RLine::ControlCharacter.new((char.ord - '@'.ord).chr)
  end

  def teardown
    screen.verify
  end

  def call(*args)
    subject.call(*args)
  end

  def test_enter
    assert_equal RLine::Exit.new, call(RLine::Enter.new)
  end

  def test_eof
    assert_equal RLine::Exit.new, call(RLine::EOF.new)
  end

  def test_char
    char = ('a'..'z').to_a.sample
    result = rand
    screen.expect(:print_char, result, [char])

    assert_equal result, call(RLine::Character.new(char))
  end

  def test_backspace
    result1 = rand
    result2 = rand

    screen.expect(:left, result1)
    screen.expect(:kill, result2)

    assert_equal [result1, result2], call(RLine::Backspace.new)
  end

  def test_left
    result = rand

    screen.expect(:left, result)

    assert_equal result, call(RLine::ArrowLeft.new)
  end

  def test_right
    result = rand

    screen.expect(:right, result)

    assert_equal result, call(RLine::ArrowRight.new)
  end

  def test_delete
    result = rand

    screen.expect(:kill, result)

    assert_equal result, call(RLine::Delete.new)
  end

  def test_ctrl_u
    left_result = rand
    kill_result = rand
    cursor = 5

    2.times do
      screen.expect(:cursor, cursor)
    end

    cursor.times do
      screen.expect(:left, left_result)
      screen.expect(:kill, kill_result)
    end

    assert_equal [left_result, kill_result] * cursor, call(ctrl_('u'))
  end
end
