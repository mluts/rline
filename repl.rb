$: << File.expand_path('../lib', __FILE__)
require 'rline'

rline = RLine.new

loop do
  line = rline.readline('> ')
  break if line.nil?
  line.strip!
  unless line.empty?
    puts "=> #{eval(line).inspect}"
  end
end
