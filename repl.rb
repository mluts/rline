#!/usr/bin/env ruby
$: << File.expand_path('../lib', __FILE__)
require 'rline'

binding = Object.new.send(:binding)

until [nil, 'q', 'quit', 'exit'].include?(input = RLine.gets)
  printf(
    "=> %s\r\n",
    begin
      binding.eval(input)
    rescue StandardError, SyntaxError => ex
      ex
    end.inspect
  )
end
