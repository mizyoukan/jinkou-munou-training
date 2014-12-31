#!/usr/bin/env ruby
# encoding: utf-8

class Responder
  def initialize(name)
    @name = name
  end

  def response(input)
    return "#{input}って何ですか？"
  end

  def name
    return @name
  end
end

class Munoko
  def initialize(name)
    @name = name
    @responder = Responder.new('What')
  end

  def dialogue(input)
    return @responder.response(input)
  end

  def responder_name
    return @responder.name
  end

  def name
    return @name
  end
end

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
