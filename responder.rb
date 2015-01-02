#!/usr/bin/env ruby
# encoding: utf-8

require 'sqlite3'

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
    @db = 'munoko.db'
  end

  def response(input)
    SQLite3::Database.new(@db) do |db|
      db.execute('SELECT text FROM random ORDER BY RANDOM() LIMIT 1') do |row|
        return row[0]
      end
    end
    return ""
  end
end
