class YoutubeController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  GOOGLE_API_KEY = ENV['GOOGLE_APP_SECRET']
  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY

  def index
    api_responce
    @videos = like_videos
    @youtube_data = find_videos('加藤純一')
  end

  private

  def _order
    %w[rating relevance title videoCount viewCount].sample
  end

  def find_videos(keyword)
    option = { q: keyword, type: 'video', max_results: 1, order: _order }
    @@service.list_searches('snippet', option)
  end

  def api_responce
    @uri = URI('https://www.googleapis.com/youtube/v3/videos')
    @uri.query = URI.encode_www_form({part: 'snippet', max_results: 1, my_rating: 'like', key: "#{GOOGLE_API_KEY}"})
    @url = URI.parse("http://localhost:3000/#{@uri.query}")
  end

  def like_videos
    option = {
      max_results: 1,
      # my_rating: 'like',
      chart: 'most_popular',
    }
    @@service.list_videos('snippet', option)
  end
end
