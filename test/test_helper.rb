$-d = true if ENV['DEBUG']

require 'bundler/setup'
$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun' unless ENV.has_key?('GUARD')
require 'minitest/reporters'

require 'rline'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class TestCase < Minitest::Test
end

Dir[File.expand_path('../support/*.rb', __FILE__)].each { |f| require(f) }

RLine::Line.term_class = FakeTerm
