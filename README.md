# youtube 5 recommends

このリポジトリを見てくれてありがとう!  
このwebアプリのメイン機能はOAuth2.0の認証機能を利用してgoogleアカウントから利用者が過去に高評価した動画をとってくるというものです  
OAuth認証を突破していないホーム画面はこのようになっています  
UIはYouTubeになるべく寄せるようにしています パッと見はYouTube!!

<img width="1128" alt="スクリーンショット 2021-01-19 163920" src="https://user-images.githubusercontent.com/70265286/105003100-960c6400-5a75-11eb-8bc4-aa8708844d25.png">  

そして認証を通すとこのようなviewになります  
<img width="1128" alt="スクリーンショット 2021-01-19 122220" src="https://user-images.githubusercontent.com/70265286/105003592-31053e00-5a76-11eb-8b75-0a771cd94283.png">
　　
  
  
環境を紹介します

* Ruby version 2.5.8

* Rails version 6.1.1

* JavaScript Library Swiper.js version 6.4.5

* API YouTube Data API v3 <https://developers.google.com/youtube/v3/docs?hl=ja%2Fs%2Fresults%2F%3Fq%3Dscopes>

* Database mySQL(このアプリはデータベースを必要としません)　　
　　
  

## YouTube Data APIについて
### YouTube Data APIを使う  
このAPIを使うならこのようにkeyを格納しておきます
  
  
```Ruby
 @@service = Google::Apis::YoutubeV3::YouTubeService.new
 @@service.key = YOUR_API_KEY
```
  
#### 認証を必要としないリクエスト
認証を必要としないリクエストは実に容易く行うことができます  
例えば特定のキーワードで検索した動画をとってくるにはこれだけです。
  
  
```Ruby
    option = { q: keyword, type: 'video' }
    @@service.list_searches('snippet', option)
```

## 認証から表示までのフロー  
### 1. リクエストの送信 
viewからリクエストを送ります  

```html
    <%= link_to "このボックスをクリックしgoogleアカウントを認証するとアプリが使えます", "https://accounts.google.com/o/oauth2/auth?client_id=YOUR_CLIENT_ID&redirect_uri=REDIRECT_URI&scope=https://www.googleapis.com/auth/youtube&response_type=code"%>
```
  
  
  
### 2. アクセストークンの取得
ユーザーが承認したらredirect_uriに追加されたcodeパラメーターを取得  
codeパラメーターを含めたPOSTリクエストを<https://accounts.google.com/o/oauth2/token>に投げるとアクセストークンをレスポンスとして返してくれます  
そしてアクセストークンの取得を試みます。
```Ruby
    response_hash = URI.decode_www_form(request.fullpath).to_h
    redirect_code = response_hash['/?code']

    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    headers = { 'Contant-Type' => 'application/x-www-form-urlencoded' }
    params = {
      code: "#{redirect_code}",
      client_id: "YOUR_CLIENT_ID",
      client_secret: "#{CLIENT_SECRET}",
      redirect_uri: 'REDIRECT_URI',
      grant_type: 'authorization_code',
    }
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)
    req.initialize_http_header(headers)

    response = http.request(req)
    @access_token = JSON.parse(response.body)['access_token']

    return @access_token
```

   
### 3. YouTube Data API の呼び出し  
アクセストークンを取得した後、承認済みのAPIリクエストを送信します
OAuth認証を挟んだのは認証を挟まない使用できないオプションがあるためです  
  
```Ruby
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

    req = Net::HTTP::Get.new(uri.request_uri)
    req.initialize_http_header(headers)

    response = https.request(req)
    response = response.body.force_encoding('UTF-8')
    response = JSON.parse(response)
    @items = response['items'].shuffle[0..4]
    return @items

```

オプションパラメーターには実に様々なものがあります  
my_ratingなど特定のオプションには認証が必要です。

