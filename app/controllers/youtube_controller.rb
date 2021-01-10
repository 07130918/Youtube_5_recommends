class YoutubeController < ApplicationController
  GOOGLE_API_KEY = ENV['GOOGLE_APP_SECRET']
  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY
  
  def find_videos(keyword)
    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 1
    }
    @@service.list_searches(:snippet, opt)
  end

  # def good_video
  #   opt = {
  #     # type: 'video',
  #     max_results: 5,
  #     myRating: 'like'
  #   }
  #   @service.list_videos("snippet", opt)
  # end

  def index
    # @videos = good_video
    @youtube_data = find_videos('加藤純一切り抜き集')
  end
end
