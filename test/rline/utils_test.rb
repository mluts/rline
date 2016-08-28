require 'test_helper'
require 'rline/utils'

class RLine::UtilsTest < TestCase
  def subject
    RLine::Utils
  end

  def test_break_text
    assert_equal [
      'de12345',
      'qwert67890'
    ], subject.break_text('abcde12345qwert67890', 3, 10)

    assert_equal [
      '90'
    ], subject.break_text('abcde12345qwert67890', 18, 10)

    assert_equal [
      '45',
      'qwert',
      '67890',
      '12'
    ], subject.break_text('abcde12345qwert6789012', 8, 5)
  end
end
