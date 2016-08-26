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

    io.buf.replace RLine::StandardInput::EOT.chars
    assert_equal RLine::EOF.new, subject.next

    io.buf.replace RLine::StandardInput::ENTER.chars
    assert_equal RLine::Enter.new, subject.next

    io.buf.replace RLine::StandardInput::BACKSPACE.chars
    assert_equal RLine::Backspace.new, subject.next
  end
end
