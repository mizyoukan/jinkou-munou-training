#!/usr/bin/env ruby

require 'sqlite3'

class Dictionary
  def initialize
    @db_file = 'munoko.db'
  end

  def randoms
    SQLite3::Database.new(@db_file) do |db|
      return db.execute('SELECT * FROM randoms').collect {|it| it[0]}
    end
  end

  def patterns
    SQLite3::Database.new(@db_file) do |db|
      sql = <<-SQL
      SELECT pattern, phrase
      FROM patterns pat JOIN pattern_phrases phr ON pat.id = phr.pattern_id
      SQL
      patterns = {}
      db.execute(sql) do |row|
        if patterns.key?(row[0])
          patterns[row[0]].push(row[1])
        else
          patterns.store(row[0], [row[1]])
        end
      end
      return patterns
    end
  end
end
