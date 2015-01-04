#!/usr/bin/env ruby

require_relative 'responder'
require_relative 'dictionary'

class Emotion
  MOOD_MIN = -15
  MOOD_MAX = 15
  MOOD_RECOVERY = 0.5

  def initialize(dictionary)
    @dictionary = dictionary
    @mood = 0
  end

  def update(input)
    pattern = @dictionary.patterns.find {|item| item.match(input) }
    if pattern
      adjust_mood(pattern.modify)
    end

    if @mood < 0
      @mood += MOOD_RECOVERY
    elsif @mood > 0
      @mood -= MOOD_RECOVERY
    end
  end

  def adjust_mood(val)
    @mood += val
    if @mood > MOOD_MAX
      @mood = MOOD_MAX
    elsif @mood < MOOD_MIN
      @mood = MOOD_MIN
    end
  end

  attr_reader :mood
end

class Munoko
  def initialize(name)
    @name = name
    @dictionary = Dictionary.new
    @emotion = Emotion.new(@dictionary)

    @resp_what = WhatResponder.new('What', @dictionary)
    @resp_random = RandomResponder.new('Random', @dictionary)
    @resp_pattern = PatternResponder.new('Pattern', @dictionary)
    @resp_template = TemplateResponder.new('Template', @dictionary)
    @resp_markov = MarkovResponder.new('Markov', @dictionary)
    @responder = @resp_pattern
  end

  def dialogue(input)
    @emotion.update(input)

    case rand(100)
    when 0..29
      @responder = @resp_pattern
    when 30..49
      @responder = @resp_template
    when 50..69
      @responder = @resp_random
    when 70..89
      @responder = @resp_markov
    else
      @responder = @resp_what
    end
    resp = @responder.response(input, @emotion.mood)

    @dictionary.study(input)
    resp
  end

  def responder_name
    @responder.name
  end

  def mood
    @emotion.mood
  end

  attr_reader :name
end
