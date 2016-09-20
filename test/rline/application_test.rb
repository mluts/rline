require 'test_helper'

class RLine::ApplicationTest < TestCase
  def subject
    @subject ||= RLine::Application.new(screen, prompt)
  end

  def prompt
    '> '
  end

  def screen
    @screen ||= Minitest::Mock.new
  end

  def teardown
    screen.verify
  end

  def test_resets_line_first_time
    line = 'abcd'

    tokens = Array.new(3).map { RLine::Print.new(random_char) }
    token = RLine::Print.new(random_char)

    screen.expect(:line, prompt + line)
    screen.expect(:reset_line, tokens, ['abcd'])

    expected_tokens = [*tokens, token]

    assert_equal expected_tokens, subject.call(token)
    assert_equal token, subject.call(token)
  end
end
