require 'test_helper'
require 'rline/middleware'

class RLine::MiddlewareTest < TestCase
  def test_call
    middlewares = [
      proc { |a| a + 1 }
    ] * 3

    subject = RLine::Middleware.new(*middlewares)

    assert_equal 3, subject.call(0)
  end
end
