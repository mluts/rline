$-d = true if ENV['DEBUG']

require 'bundler/setup'
$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun' unless ENV.has_key?('GUARD')
require 'minitest/reporters'

require 'rline'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class TestCase < Minitest::Test
  def ctrl_(char)
    RLine::ControlCharacter.new((char.ord - '@'.ord).chr)
  end
end
