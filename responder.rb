#!/usr/bin/env ruby
# encoding: utf-8

def select_random(ary)
  ary[rand(ary.size)]
end

class Responder
  def initialize(name, dictionary)
    @name = name
    @dictionary = dictionary
  end

  def response(input)
    ""
  end

  attr_reader :name
end

class WhatResponder < Responder
  def response(input)
    "#{input}とは何でしょうか？"
  end
end

class RandomResponder < Responder
  def response(input)
    select_random(@dictionary.randoms)
  end
end

class PatternResponder < Responder
  def response(input)
    @dictionary.patterns.each do |pattern, phrases|
      m = input.match(pattern)
      if m
        return select_random(phrases).gsub(/%match%/, m.to_s)
      end
    end
    return select_random(@dictionary.randoms)
  end
end
