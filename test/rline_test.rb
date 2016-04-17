require 'test_helper'

class RlineTest < Minitest::Test
  def setup
    @master, @slave = PTY.open
    @out = StringIO.new
    @rline = RLine.new(@slave, @master)
  end

  def teardown
    @slave.close
    @master.close
  end
end
