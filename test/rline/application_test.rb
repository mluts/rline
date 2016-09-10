require 'test_helper'

class RLine::ApplicationTest < TestCase
  def subject
    @subject ||= RLine::Application.new
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
end
