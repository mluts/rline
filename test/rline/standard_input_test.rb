require 'test_helper'

class RLine::StandardInputTest < TestCase
  class IO
    attr_reader :buf

    def initialize
      @buf = []
    end

    def raw
      yield
    end

    def getc
      @buf.shift
    end
  end

  def subject
    @subject ||= RLine::StandardInput.new(io)
  end

  def io
    @io ||= IO.new
  end

  def test_next
    io.buf.replace "\e[D".chars
    assert_equal RLine::ArrowLeft.new, subject.next
  end
end
