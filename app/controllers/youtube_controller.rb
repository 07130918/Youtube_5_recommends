class YoutubeController < ApplicationController
  GOOGLE_API_KEY = ENV['GOOGLE_APP_SECRET']

  def find_videos(keyword, after: 1.months.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 1,
      order: :date,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601,
    }
    service.list_searches(:snippet, opt)
  end

  def index
    @youtube_data = find_videos('加藤純一切り抜き集')
  end
end
