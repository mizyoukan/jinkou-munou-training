#!/usr/bin/env ruby

require 'sqlite3'

class Pattern
  def initialize(pattern, phrases, modify)
    @pattern = pattern
    @phrases = phrases
    @modify = modify
  end

  def match(str)
    str.match(@pattern)
  end

  def choice(mood)
    choices = @phrases.select {|item| suitable?(item['need'], mood) }
    choices.empty? ? nil : select_random(choices.collect {|item| item['phrase'] })
  end

  def suitable?(need, mood)
    if need > 0
      mood > need
    elsif need < 0
      mood < need
    else
      true
    end
  end

  attr_reader :pattern, :phrases, :modify
end

class Dictionary
  def initialize
    @db_file = 'munoko.db'
  end

  def randoms
    SQLite3::Database.new(@db_file) do |db|
      return db.execute('SELECT * FROM randoms').collect {|it| it[0] }
    end
  end

  def patterns
    SQLite3::Database.new(@db_file) do |db|
      sql = <<-SQL
      SELECT pattern_id, pattern, phrase, need, modify
      FROM patterns pat JOIN pattern_phrases phr ON pat.id = phr.pattern_id
      SQL
      return db.execute(sql).group_by {|item| item[0] }.values.collect{|value|
        Pattern.new(
          value[0][1],
          value.collect {|item| {'phrase' => item[2], 'need' => item[3].to_i} },
          value[0][4].to_i
        )
      }
    end
  end

  def study(input)
    return if randoms.include?(input)
    SQLite3::Database.new(@db_file) do |db|
      db.transaction do
        db.prepare("INSERT INTO randoms (text) VALUES (?)") do |p|
          p.execute(input)
        end
      end
    end
  end
end
