$-d = true if ENV['DEBUG']

require 'bundler/setup'
$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun' unless ENV.has_key?('GUARD')
require 'minitest/reporters'

require 'rline'
require 'pty'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class FakeTTY
  def initialize(input = '')
    @io = StringIO.new(input, 'r')
  end

  def replace(string)
    raise "string must be String" unless string.is_a?(String)
    @io = StringIO.new(string, 'r')
  end

  def getch
    raise "EOF" if @io.eof?
    @io.getc
  end

  def tty?
    true
  end
end

class FakeTerminal
  attr_reader :line

  def initialize
    @line = ''
  end

  def reset_line
    @line.clear
  end

  def newline
    @line << "\n"
  end

  def print(*args)
    args.each { |arg| line << arg }
  end
end
