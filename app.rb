require "stream"
require "sinatra"

APIKEY = ""
SECRET = ""
APPID = ""

get "/" do
  @apikey = APIKEY
  @secret = SECRET
  @appid = APPID
  client = Stream::Client.new(@apikey, @secret, @appid, { location: 'us-east' })
  eric_feed = client.feed('user', 'eric')
  @token = eric_feed.readonly_token

  erb :"index.html"
end

get "/add_activity" do
  @apikey = APIKEY
  @secret = SECRET
  @appid = APPID
  client = Stream::Client.new(@apikey, @secret, @appid, { location: 'us-east' })
  eric_feed = client.feed('user', 'eric')

  activity_data = {
    actor: "eric",
    verb: "tweet",
    object: 1,
    tweet: "Hello World"
  }

  activity_response = eric_feed.add_activity(activity_data)

  ""
end
