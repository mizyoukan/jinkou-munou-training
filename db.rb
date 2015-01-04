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
    pattern TEXT NOT NULL,
    modify INTEGER NOT NULL DEFAULT 0
  );
  DROP TABLE IF EXISTS pattern_phrases;
  CREATE TABLE pattern_phrases (
    pattern_id INTEGER NOT NULL,
    phrase TEXT NOT NULL,
    need INTEGER NOT NULL DEFAULT 0
  );
  DROP TABLE IF EXISTS templates;
  CREATE TABLE templates (
    noun_count INTEGER NOT NULL,
    text TEXT NOT NULL
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

  patterns = [
    {'pattern' => '^hi|こんにち[はわ]$', 'phrases' => [{'phrase' => 'こんにちは', 'need' => 0}], 'modify' => 0},
    {'pattern' => '^(かわいい|可愛い)$', 'phrases' => [{'phrase' => 'ありがとうございます', 'need' => 0}, {'phrase' => 'そんな、%match%だなんて・・・', 'need' => 1}], 'modify' => 2},
    {'pattern' => '^さよう?なら$', 'phrases' => [{'phrase' => 'さようなら', 'need' => 0}, {'phrase' => 'またいらしてくださいね', 'need' => 0}], 'modify' => 0},
    {'pattern' => '^サヨナラ[!！]$', 'phrases' => [{'phrase' => 'お達者で', 'need' => 0}], 'modify' => 0},
  ]
  db.transaction do
    db.prepare('INSERT INTO patterns (id, pattern, modify) VALUES (NULL, ?, ?)') do |ppat|
      db.prepare('INSERT INTO pattern_phrases (pattern_id, phrase, need) VALUES (?, ?, ?)') do |pphr|
        patterns.each do |pattern|
          ppat.execute(pattern['pattern'], pattern['modify'])
          pattern['phrases'].each do |phrase|
            pphr.execute(db.last_insert_row_id, phrase['phrase'], phrase['need'])
          end
        end
      end
    end
  end

  templates = [
    '%noun%してますか？',
    '%noun%ですか？',
    '%noun%は%noun%ですか？',
    '%noun%は%noun%な%noun%'
  ]
  db.transaction do
    db.prepare('INSERT INTO templates (noun_count, text) VALUES (?, ?)') do |p|
      templates.each do |template|
        noun_count = template.scan(/%noun%/).size
        p.execute(noun_count, template)
      end
    end
  end
end
