require 'test_helper'

class RLine::Mapping::EmacsTest < TestCase
  def subject
    RLine::Mapping::Emacs.new(screen, history, prompt)
  end

  def screen
    @screen ||= Minitest::Mock.new
  end

  def history
    @history ||= Minitest::Mock.new
  end

  def prompt
    '> '
  end

  def test_beginning_of_line
    cursor = 10
    token = rand
    tokens_count = cursor - prompt.size

    screen.expect(:cursor, cursor)

    tokens_count.times do
      screen.expect(:left, token)
    end

    assert_equal Array.new(tokens_count, token),
                 subject.call(ctrl_('a'))
  end
end
