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
end
