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
  end

  def test_enter
    io.buf.replace "\r".chars
    assert_equal RLine::Enter.new("\r"), subject.next
  end

  def test_backspace
    io.buf.replace RLine::StandardInput::BACKSPACE.chars
    assert_equal RLine::Backspace.new(RLine::StandardInput::BACKSPACE), subject.next
  end

  def test_control_char
    io.buf.replace "\u0015".chars
    assert_equal RLine::ControlCharacter.new("\u0015"), subject.next
  end

  def test_tab
    io.buf.replace "\t".chars
    assert_equal RLine::Tab.new("\t"), subject.next
  end
end
