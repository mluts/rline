require 'test_helper'

class RLine::EscapeSequenceTest < TestCase
  def subject
    @subject ||= RLine::EscapeSequence.new
  end

  def test_two_character_sequence
    refute_predicate subject, :complete?

    subject.push '['
    refute_predicate subject, :complete?

    subject.push 'D'
    assert_predicate subject, :complete?
  end

  def test_multiple_character_sequence
    refute_predicate subject, :complete?

    subject.push '['
    refute_predicate subject, :complete?

    subject.push '1'
    refute_predicate subject, :complete?

    subject.push '~'
    assert_predicate subject, :complete?
  end
end
