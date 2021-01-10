class YoutubeController < ApplicationController
  GOOGLE_API_KEY = ENV['GOOGLE_APP_SECRET']
  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY
  
  def _order
    ["date", "rating", "relevance", "title", "videoCount", "viewCount"].sample
  end

  def find_videos(keyword)
    opt = {
      q: keyword,
      type: 'video',
      max_results: 1,
      order: _order,
    }
    @@service.list_searches(:snippet, opt)
  end

  # def good_video
  #   opt = {
  #     max_results: 5,
  #     my_rating: 'like'
  #   }
  #   @@service.list_videos("snippet", opt)
  # end

  def index
    # @videos = good_video
    @youtube_data = find_videos('加藤純一切り抜き集')
  end
end
