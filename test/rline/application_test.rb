require 'test_helper'

class RLine::ApplicationTest < TestCase
  def subject
    @subject ||= RLine::Application.new(screen)
  end

  def screen
    @screen ||= Minitest::Mock.new
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

    screen.verify
  end
end
