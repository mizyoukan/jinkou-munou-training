#!/usr/bin/env ruby
# encoding: utf-8

require 'sqlite3'

SQLite3::Database.new('munoko.db') do |db|
  create_sqls = <<-SQL
  DROP TABLE IF EXISTS random;
  CREATE TABLE random (
    text TEXT
  );
  SQL
  db.execute_batch(create_sqls)

  random_texts = [
    '今日は寒いですね',
    'チョコレートが食べたいです',
    '昨日10円拾いました'
  ]

  db.transaction do
    db.prepare("INSERT INTO random (text) VALUES (?)") do |p|
      random_texts.each do |text|
        p.execute(text)
      end
    end
  end
end
