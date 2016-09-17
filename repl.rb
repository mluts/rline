$: << File.expand_path('../lib', __FILE__)
require 'rline'

until ['', 'q', 'quit', 'exit'].include?(input = RLine.gets)
  printf(
    "=> %s\r\n",
    begin
      eval(input)
    rescue StandardError, SyntaxError => ex
      ex
    end.inspect
  )
end
