class YoutubeController < ApplicationController
  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.key = GOOGLE_API_KEY

  def index
    youtube_data_api
  end

  def create
    #もし検索ボックスから何かされても大丈夫なように
    redirect_to root_path
  end

  private

  # コードとアクセストークンを交換する関数
  def get_access_token
    # OAuth 2.0 の承認を突破した段階でurlのcode=~~の部分を取得
    # redirect_codeは後にアクセストークン、更新トークンと交換
    # リクエスト送信に必要なため
    response_hash = URI.decode_www_form(request.fullpath).to_h
    redirect_code = response_hash['/?code']

    # parseでuriを区切れるようになる
    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # POST リクエストを https://accounts.google.com/o/oauth2/token に送信
    headers = { 'Contant-Type' => 'application/x-www-form-urlencoded' }
    params = {
      code: "#{redirect_code}",
      client_id:
        '660241016882-pl2v6ilg0k0vqi3eqdqekv6risb565pp.apps.googleusercontent.com',
      client_secret: "#{CLIENT_SECRET}",
      redirect_uri: 'http://localhost:3000/',
      grant_type: 'authorization_code',
    }
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)
    req.initialize_http_header(headers)

    # リクエストのレスポンスからトークン取得
    response = http.request(req)
    @access_token = JSON.parse(response.body)['access_token']
    @response_body = JSON.parse(response.body)
    # 後で(使うなら)refresh_tokenもreturn
    return @access_token
  end

  # アクセストークンを利用し承認されたリクエストも行える Yoyube Data Api 呼び出し関数
  def youtube_data_api
    get_access_token
    if @access_token
      option = { my_rating: 'like', max_results: 50 }
      uri =
        URI.parse(
          "https://www.googleapis.com/youtube/v3/videos?part=snippet&maxResults=#{
            option[:max_results]
          }&myRating=#{option[:my_rating]}",
        )

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE

      headers = { 'Authorization' => "Bearer #{@access_token}" }

      # request_uriはyoutube/v3/videos?part=snippet&maxResults=#{option[:max_results]}&myRating=#{option[:my_rating]}を指す
      req = Net::HTTP::Get.new(uri.request_uri)
      req.initialize_http_header(headers)

      # エンコード→操作しやすいようにハッシュに
      #ハッシュドポテト
      response = https.request(req)
      response = response.body.force_encoding('UTF-8')
      response = JSON.parse(response)
      # ランダムに5つの動画を返す
      @items = response['items'].shuffle[0..4]
      return @items
    end
  end
end
