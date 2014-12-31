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

