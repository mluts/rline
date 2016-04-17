$-d = true if ENV['DEBUG']

require 'bundler/setup'
$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun' unless ENV.has_key?('GUARD')
require 'minitest/reporters'

require 'rline'
require 'pty'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
