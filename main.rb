#!/usr/bin/env ruby

require_relative 'munoko'

def prompt(munoko)
  return munoko.name + ':' + munoko.responder_name + '> '
end

puts('Jinkou-Munou system [munoko]')
m = Munoko.new('Munoko')
while true
  print('> ')
  input = gets
  input.chomp!
  break if input == 'exit'

  response = m.dialogue(input)
  puts(prompt(m) + response)
end
