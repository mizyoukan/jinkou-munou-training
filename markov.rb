#!/usr/bin/env ruby
# coding: utf-8

require 'sqlite3'
require_relative 'morph'
require_relative 'utils'

class Markov
  CHAIN_MAX = 30

  def initialize(db)
    @dict = {}
    @db = db
    load
  end

  def load
    SQLite3::Database.new(@db) do |db|
      db.transaction do
        db.execute('SELECT prefix1, prefix2, suffix FROM markov') do |p1, p2, s|
          @dict[p1] = {} unless @dict.key?(p1)
          @dict[p1][p2] = [] unless @dict[p1].key?(p2)
          unless @dict[p1][p2].include?(s)
            @dict[p1][p2].push(s)
          end
        end
      end
    end
  end

  def add_sentence(input)
    parts = Morph::analyze(input)
    return if parts.count < 3

    SQLite3::Database.new(@db) do |db|
      db.transaction do
        db.prepare('INSERT INTO markov (prefix1, prefix2, suffix) VALUES (?, ?, ?)') do |p|
          parts.collect{|part| Morph::keyword(part) }.each_cons(3) do |p1, p2, s|
            @dict[p1] = {} unless @dict.key?(p1)
            @dict[p1][p2] = [] unless @dict[p1].key?(p2)
            unless @dict[p1][p2].include?(s)
              @dict[p1][p2].push(s)
              p.execute(p1, p2, s)
            end
          end
        end
      end
    end
  end

  def generate(keyword)
    return nil unless @dict.key?(keyword)
    prefix1, prefix2 = keyword, select_random(@dict[keyword].keys)
    words = [prefix1, prefix2]
    CHAIN_MAX.times do
      break unless @dict.key?(prefix1)
      break unless @dict[prefix1].key?(prefix2)
      break if @dict[prefix1][prefix2].empty?
      suffix = select_random(@dict[prefix1][prefix2])
      break unless suffix
      words.push(suffix)
      prefix1, prefix2 = prefix2, suffix
    end
    words.join
  end
end
