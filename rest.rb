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
    body = request.body.read
    print("Body: [#{body}]\n")
    req = JSON.parse(body)
    print("Request: [#{req}]\n")
    input = req["input"]
    if input
      response = munoko.dialogue(input)
      content_type :json
      {
        name: munoko.name,
        responderName: munoko.responder_name,
        message: response
      }.to_json
    else
      content_type :json
      {}.to_json
    end
  rescue JSON::ParserError => e
    status 500
  end
end
