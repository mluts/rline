require 'test_helper'

class RLine::ApplicationTest < TestCase
  def subject
    @subject ||= RLine::Application.new
  end

  def test_print_char
    char = 'a'
    assert_equal RLine::Print.new(char),
                 subject.call(RLine::Character.new(char))
  end
end
