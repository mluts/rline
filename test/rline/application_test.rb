require 'test_helper'

class RLine::ApplicationTest < TestCase
  def subject
    @subject ||= RLine::Application.new
  end

  def call(*args)
    subject.call(*args)
  end

  def test_print_char
    char = 'a'
    assert_equal RLine::Print.new(char),
                 call(RLine::Character.new(char))
  end

  def test_backspace
    assert_equal RLine::DeleteLeft.new,
                 call(RLine::Backspace.new)
  end

  def test_arrows
    assert_equal RLine::Move.new(-1),
                 call(RLine::ArrowLeft.new)
  end

  def test_enter
    assert_equal RLine::Exit.new, call(RLine::Enter.new)
  end
end
