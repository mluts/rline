require 'test_helper'

class RLine::LineTest < TestCase
  def subject
    @subject ||= RLine::Line.new
  end

  def test_eof
    assert_nil subject.gets
  end
end
