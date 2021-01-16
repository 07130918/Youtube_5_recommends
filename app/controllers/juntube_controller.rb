class JuntubeController < ApplicationController
  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY

  def index
    @youtube_data = find_videos('加藤純一切り抜き')
  end

  private
  
  def _order
    %w[rating relevance title videoCount viewCount].sample
  end

  def find_videos(keyword)
    option = { q: keyword, type: 'video', max_results: 1, order: _order }
    @@service.list_searches('snippet', option)
  end
end
