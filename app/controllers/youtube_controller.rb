class YoutubeController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  GOOGLE_API_KEY = ENV['GOOGLE_APP_SECRET']
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']

  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY

  def index
    @youtube_data = find_videos('加藤純一')
    youtube_data_api
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

  def get_accecc_token
    # parseでuriを区切れるようになる
    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # OAuth 2.0 の承認を突破した段階でurlのcode=~~の部分を取得
    # @redirect_codeは後にアクセストークン、更新トークンと交換
    # リクエスト送信に必要なため
    response_hash = URI.decode_www_form(request.fullpath).to_h
    @redirect_code = response_hash['/?code']
    req_header = { 'Contant-Type' => 'application/x-www-form-urlencoded' }

    # POST リクエストを https://accounts.google.com/o/oauth2/token に送信
    req = Net::HTTP::Post.new(uri.request_uri, req_header)
    req.body =
      "code=#{@redirect_code}&client_id=#{CLIENT_ID}&client_secret=#{
        CLIENT_SECRET
      }&redirect_uri=http://localhost:3000/&grant_type=authorization_code"

    # リクエストのレスポンスからトークン取得
    response = http.request(req)
    @access_token = JSON.parse(response.body)['access_token']

    # 後で(使うなら)refresh_tokenもreturn
    return @access_token
  end

  def youtube_data_api
    get_accecc_token

    # GETリクエストでアクセストークンを利用する YouTube Data API の呼び出し
    # 今やりたい事→ちゃんと条件通りにyoutubeからgetリクエストで情報をもらう
    option = { my_rating: 'like', max_results: 1 }
    uri =
      URI.parse(
        "https://www.googleapis.com/youtube/v3/videos?part=snippet&myRating=#{
          option[:my_rating]
        }&maxResults=#{option[:max_results]}",
      )
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    header = { Authorization: "Bearer #{@access_token}" }

    req = Net::HTTP::Get.new(uri.path)
    # uri.request_uriとuri.pathの違い
    req.initialize_http_header(headers)
    req['X-API-KEY'] = GOOGLE_API_KEY
    response = https.request(req)
    @response = response.body.force_encoding('UTF-8')
  end
end
