
require "sinatra"
require "sinatra/config_file"
require "json"
require "stream"

config_file "secrets.yml"
APIKEY = settings.apikey
SECRET = settings.secret
APPID = settings.appid
LOCATION = settings.location

get "/" do
  client = Stream::Client.new(APIKEY, SECRET, APPID, { location: LOCATION })

  user_feed = client.feed('user', '7')
  @user_token = user_feed.readonly_token

  notification_feed = client.feed('notification', '7')
  @notification_token = notification_feed.readonly_token

  @apikey = APIKEY
  @appid = APPID
  erb :"index.html"
end

get "/add_activity" do
  client = Stream::Client.new(APIKEY, SECRET, APPID, { location: LOCATION })
  feed = client.feed('user', '7')

  activity_data = {
    actor: "7",
    verb: "test",
    object: 0,
  }

  activity_response = feed.add_activity(activity_data)

  content_type :json

  @apikey = APIKEY
  @appid = APPID
  { success: true, data: activity_response }
end
