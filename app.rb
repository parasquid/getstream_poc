
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

  @user_id = 7
  user_feed = client.feed('user', @user_id)
  @user_token = user_feed.readonly_token

  notification_feed = client.feed('notification', @user_id)
  @notification_token = notification_feed.readonly_token

  @apikey = APIKEY
  @appid = APPID
  erb :"index.html"
end

get "/add_activity" do
  client = Stream::Client.new(APIKEY, SECRET, APPID, { location: LOCATION })
  @user_id = 7

  activity_data = {
    actor: @user_id,
    verb: "test",
    object: 0,
  }

  user_feed = client.feed('user', @user_id)
  notification_feed = client.feed('notification', @user_id)

  user_activity_response = user_feed.add_activity(activity_data)
  notification_activity_response = notification_feed.add_activity(activity_data)

  content_type :json

  @apikey = APIKEY
  @appid = APPID
  {
    success: true,
    data: {
      user: user_activity_response,
      notification: notification_activity_response,
    }
  }.to_json
end
