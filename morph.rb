#!/usr/bin/env ruby
# coding: utf-8

require 'natto'

module Morph
  def analyze(text)
    natto = Natto::MeCab.new
    natto.enum_parse(text)
  end

  def keyword(part)
    part.surface
  end

  def keyword?(part)
    /^名詞,(一般|固有名詞|サ変接続|形容動詞語幹)/ =~ part.feature
  end

  module_function :analyze, :keyword, :keyword?
end
