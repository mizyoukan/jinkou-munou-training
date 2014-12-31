#!/usr/bin/env ruby
# encoding: utf-8

class Responder
  def initialize(name)
    @name = name
  end

  def response(input)
    return ''
  end

  def name
    return @name
  end
end

class WhatResponder < Responder
  def response(input)
    return "#{input}って何ですか？"
  end
end

class RandomResponder < Responder
  def initialize(name)
    super
    @responses = ['今日は寒いですね', 'チョコレートが食べたいです', '昨日10円拾いました']
  end

  def response(input)
    return @responses[rand(@responses.size)]
  end
end

