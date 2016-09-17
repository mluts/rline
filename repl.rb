#!/usr/bin/env ruby
$: << File.expand_path('../lib', __FILE__)
require 'rline'

until [nil, 'q', 'quit', 'exit'].include?(input = RLine.gets)
  printf(
    "=> %s\r\n",
    begin
      eval(input)
    rescue StandardError, SyntaxError => ex
      ex
    end.inspect
  )
end
