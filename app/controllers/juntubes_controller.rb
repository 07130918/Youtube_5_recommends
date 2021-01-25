class JuntubesController < ApplicationController
  def index
    @@service = Google::Apis::YoutubeV3::YouTubeService.new
    @@service.key = ENV['GOOGLE_APP_SECRET']
    puts "----------------------"
    puts @@service.key
    puts "----------------------"
    response = youtube_search('加藤純一切り抜き')
    @items = response.items
  end

  private
  
  def _order
    %w[relevance videoCount viewCount].sample
  end

  def youtube_search(keyword)
    option = { q: keyword, type: 'video', max_results: 1, order: _order }
    resopnse = @@service.list_searches('snippet', option)
    return resopnse
  end
end