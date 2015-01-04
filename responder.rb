#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'dictionary'
require_relative 'morph'

def select_random(ary)
  ary[rand(ary.size)]
end

class Responder
  def initialize(name, dictionary)
    @name = name
    @dictionary = dictionary
  end

  def response(input, mood)
    ""
  end

  attr_reader :name
end

class WhatResponder < Responder
  def response(input, mood)
    "#{input}とは何でしょうか？"
  end
end

class RandomResponder < Responder
  def response(input, mood)
    select_random(@dictionary.randoms)
  end
end

class PatternResponder < Responder
  def response(input, mood)
    @dictionary.patterns.each do |pattern|
      if m = pattern.match(input)
        resp = pattern.choice(mood)
        next if resp.nil?
        return resp.gsub(/%match%/, m.to_s)
      end
    end
    return select_random(@dictionary.randoms)
  end
end

class TemplateResponder < Responder
  def response(input, mood)
    parts = Morph::analyze(input)
    keywords = Morph::keywords(parts)
    return select_random(@dictionary.randoms) if keywords.empty?

    templates = @dictionary.templates
    return select_random(@dictionary.randoms) unless templates.key?(keywords.count)

    template = select_random(templates[keywords.count])
    return template.gsub(/%noun%/) {keywords.shift}
  end
end
