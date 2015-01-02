#!/usr/bin/env ruby
# encoding: utf-8

require 'sqlite3'

SQLite3::Database.new('munoko.db') do |db|
  create_sqls = <<-SQL
  DROP TABLE IF EXISTS randoms;
  CREATE TABLE randoms (
    text TEXT NOT NULL
  );
  DROP TABLE IF EXISTS patterns;
  CREATE TABLE patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern TEXT NOT NULL
  );
  DROP TABLE IF EXISTS pattern_phrases;
  CREATE TABLE pattern_phrases (
    pattern_id INTEGER NOT NULL,
    phrase TEXT NOT NULL
  );
  SQL
  db.execute_batch(create_sqls)

  random_texts = [
    '今日は寒いですね',
    'チョコレートが食べたいです',
    '昨日10円拾いました'
  ]

  db.transaction do
    db.prepare("INSERT INTO randoms (text) VALUES (?)") do |p|
      random_texts.each do |text|
        p.execute(text)
      end
    end
  end

  patterns = {
    '^hi|こんにち[はわ]$' => ['こんにちは'],
    '^(かわいい|可愛い)$' => ['ありがとうございます', 'そんな、%match%だなんて・・・'],
    '^さよう?なら$' => ['さようなら', 'またいらしてくださいね'],
    '^サヨナラ[!！]$' => ['お達者で'],
  }
  db.transaction do
    db.prepare('INSERT INTO patterns (id, pattern) VALUES (NULL, ?)') do |ppat|
      db.prepare('INSERT INTO pattern_phrases (pattern_id, phrase) VALUES (?, ?)') do |pphr|
        patterns.each do |pattern, phrases|
          ppat.execute(pattern)
          phrases.each do |phrase|
            pphr.execute(db.last_insert_row_id, phrase)
          end
        end
      end
    end
  end
end
