#!/usr/bin/env ruby

require_relative 'responder'

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
