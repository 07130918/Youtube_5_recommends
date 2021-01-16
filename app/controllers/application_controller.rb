class ApplicationController < ActionController::Base
  require 'net/http'
  require 'uri'
  require 'json'
  GOOGLE_API_KEY = ENV['GOOGLE_APP_SECRET']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
end
