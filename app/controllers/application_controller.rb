class ApplicationController < ActionController::Base
  require 'net/http'
  require 'uri'
  require 'json'
  CLIENT_SECRET = ENV['CLIENT_SECRET']
  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = ENV['GOOGLE_APP_SECRET']
  puts "----------------------"
  puts @@service.key
  puts "----------------------"
end
