class JuntubesController < ApplicationController
  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY

  def index
    # @youtube_search_items = youtube_search('加藤純一切り抜き').items
  end

  private
  
  def _order
    %w[rating relevance videoCount viewCount].sample
  end

  def youtube_search(keyword)
    option = { q: keyword, type: 'video', max_results: 1, order: _order }
    @@service.list_searches('snippet', option)
  end
end
