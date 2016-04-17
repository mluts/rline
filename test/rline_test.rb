require 'test_helper'

class RlineTest < Minitest::Test
  def setup
    @stdin = FakeTTY.new
    @terminal = FakeTerminal.new
    @rline = RLine.new(@stdin)

    @rline.instance_exec(@terminal) do |term|
      @terminal = term
    end
  end

  def test_simple_line
    @stdin.replace("line\r")
    assert_equal 'line', @rline.readline('> ')
    assert_equal "> line\n", @terminal.line
  end

  def test_newline
    @stdin.replace("\r")
    assert_equal "", @rline.readline('> ')
    assert_equal "> \n", @terminal.line
  end

  def test_eof
    @stdin.replace(@rline.terminfo.eof)
    assert_equal nil, @rline.readline('> ')
    assert_equal "> \n", @terminal.line
  end
end
