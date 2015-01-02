#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'sinatra/cross_origin'
require 'json'

require_relative 'munoko'

munoko = Munoko.new('Munoko')

post '/dialogue' do
  cross_origin
  begin
    req = JSON.parse(request.body.read)
    input = req["input"]
    if input
      response = munoko.dialogue(input)
      content_type :json
      {
        name: munoko.name,
        responderName: munoko.responder_name,
        message: response,
        mood: munoko.mood
      }.to_json
    else
      content_type :json
      {}.to_json
    end
  rescue JSON::ParserError => e
    status 500
  end
end

get '/mood' do
  cross_origin
  content_type :json
  {mood: munoko.mood}.to_json
end
