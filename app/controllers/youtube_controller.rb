class YoutubeController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  GOOGLE_API_KEY = ENV['GOOGLE_APP_SECRET']
  CLIENT_SECRET = ENV['CLIENT_SECRET']

  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY

  def index
    @youtube_data = find_videos('加藤純一')
    api_response
    # @videos = like_videos
  end

  private

  def _order
    %w[rating relevance title videoCount viewCount].sample
  end

  def find_videos(keyword)
    option = { q: keyword, type: 'video', max_results: 1, order: _order }
    @@service.list_searches('snippet', option)
  end

  def like_videos
    option = {
      max_results: 5,
      # my_rating: 'like',
      chart: 'most_popular',
    }
    @@service.list_videos('snippet', option)
  end

  def api_response
    # parseでuriを区切れるようになる
    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # oauth 2.0 の承認を突破した段階でurlのcode=~~の部分を取得
    # リクエスト送信に必要なため
    response_hash = URI.decode_www_form(request.fullpath).to_h
    @redirect_code = response_hash['/?code']
    req_header = { 'Contant-Type' => 'application/x-www-form-urlencoded' }
    # POST リクエストを https://accounts.google.com/o/oauth2/token に送信
    req = Net::HTTP::Post.new(uri.request_uri, req_header)
    req.body =
      "code=#{
        @redirect_code
      }&client_id=660241016882-pl2v6ilg0k0vqi3eqdqekv6risb565pp.apps.googleusercontent.com&client_secret=#{
        CLIENT_SECRET
      }&redirect_uri=http://localhost:3000/&grant_type=authorization_code"

    # リクエストのレスポンスからトークン取得
    response = http.request(req)
    @access_token = JSON.parse(response.body)['access_token']

    # GETリクエストでアクセストークンを利用する YouTube Data API の呼び出し
  
  end
end
