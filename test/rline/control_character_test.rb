require 'test_helper'

class RLine::ControlCharacterTest < TestCase
  def test_char
    assert_equal '@', RLine::ControlCharacter.new("\u0000").char
    assert_equal 'u', RLine::ControlCharacter.new("\u0015").char
    assert_equal 'o', RLine::ControlCharacter.new("\u000F").char
  end
end
