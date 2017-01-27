require 'test_helper'

class RLine::Mapping::EmacsTest < TestCase
  def subject
    @subject ||= RLine::Mapping::Emacs.new(screen, history)
  end

  def history
    @history ||= Minitest::Mock.new
  end

  def prompt
    @prompt ||= '> '
  end

  def screen
    @screen ||= Minitest::Mock.new
  end

  def test_arrow_up
    text = 'abcdefg'

    history.expect(:count, 10)
    history.expect(:count, 10)
    history.expect(:[], text, [9])
    screen.expect(:reset_line, nil, [text])

    subject.call(RLine::ArrowUp.new)

    screen.verify
  end

  def test_arrow_down
    text = 'abcdefg'

    history.expect(:count, 10)
    history.expect(:count, 10)
    history.expect(:[], text, [10])
    screen.expect(:reset_line, nil, [text])

    subject.call(RLine::ArrowDown.new)

    screen.verify
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

    assert_equal [left_result, kill_result] * cursor, subject.call(ctrl_('u'))
  end

  def test_delete
    result = rand

    screen.expect(:kill, result)

    assert_equal result, subject.call(RLine::Delete.new)
  end

  def test_left
    result = rand

    screen.expect(:left, result)

    assert_equal result, subject.call(RLine::ArrowLeft.new)
  end

  def test_right
    result = rand

    screen.expect(:right, result)

    assert_equal result, subject.call(RLine::ArrowRight.new)
  end

  def test_enter
    screen.expect(:line, prompt)
    assert_equal RLine::Exit.new(RLine::Enter.new), subject.call(RLine::Enter.new)
  end

  def test_eof
    screen.expect(:line, prompt)
    assert_equal RLine::Exit.new(RLine::EOF.new), subject.call(RLine::EOF.new)
  end

  def test_char
    char = ('a'..'z').to_a.sample
    result = rand
    screen.expect(:print_char, result, [char])

    assert_equal result, subject.call(RLine::Character.new(char))
  end

  def test_backspace
    result1 = rand
    result2 = rand

    screen.expect(:left, result1)
    screen.expect(:kill, result2)

    assert_equal [result1, result2], subject.call(RLine::Backspace.new)
  end

  def test_call_with_output_token
    token = RLine::OutputToken.new
    assert_equal token, subject.call(token)
  end

  def test_call_with_array
    token = [1,2,3]
    assert_equal token, subject.call(token)
  end
end
