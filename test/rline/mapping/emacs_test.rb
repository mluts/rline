require 'test_helper'

class RLine::Mapping::EmacsTest < TestCase
  def subject
    @subject ||= RLine::Mapping::Emacs.new(screen, history, prompt)
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
end
