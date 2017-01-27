require 'test_helper'

class RLine::CompletionTest < TestCase
  def subject
    @subject ||= RLine::Completion.new(screen, completion_proc)
  end

  def screen
    @screen ||= Minitest::Mock.new
  end

  def completion_proc
    @completion_proc ||= proc{[]}
  end

  def test_output_token
    token = RLine::OutputToken.new(rand)

    assert_equal token, subject.call(token)
  end

  def test_array
    token = [1,2,3]

    assert_equal token, subject.call(token)
  end
end
