require 'sinatra'
require 'haml'
require 'mongo'
require 'json/ext' # required for .to_json

include Mongo

$LOAD_PATH << '.'
require 'message'
require 'advert'

configure do
  enable :sessions
  conn = Mongo::Client.new( [ '127.0.0.1:27017' ], :database => 'dodjo' )
  set :mongo_connection, conn
  set :mongo_db, conn.db('')
end

helpers do

  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ 'svi4', 'dreamless' ]
  end

  def apps_list
    Advert.index
  end

end

#admin pages
get '/admin/offers' do
  protected!
  haml :admin_offers_index, locals: { apps_list: Advert.index }, layout: :admin_layout
end

get '/admin/offers/:name' do
  haml :admin_offer_show, locals: { apps_list: Advert.index }
end

post '/admin/offers' do
  content_type :json
  haml :admin_offers_index, locals: { apps_list: Advert.index }
end

put '/admin/offers/:name' do
  haml :admin_offer_show, locals: { apps_list: Advert.index }
end

patch '/admin/offers/:name' do
  haml :admin_offer_show, locals: { apps_list: Advert.index }
end

delete '/admin/offers/:name' do
  haml :admin_offer_show, locals: { apps_list: Advert.index }
end

#landing pages
apps_list = Advert.index
get '/' do
  haml :index, locals: { messages: Message.index, apps_list: Advert.index }
end

get '/apps' do
  haml :index, locals: { messages: Message.index, apps_list: Advert.apps }
end

get '/games' do
  haml :index, locals: { messages: Message.index, apps_list: Advert.games }
end

get '/apps/:name' do
  app_name = params[ :name ]
  haml :landing, locals: { app: apps_list[ app_name.to_sym ], app_name: app_name }
end

get '/games/:name' do
  app_name = params[ :name ]
  haml :landing, locals: { app: apps_list[ app_name.to_sym ], app_name: app_name }
end

get '/lazy' do
  haml :lazy, locals: { lazy: Advert.apps[ :lazy ] }
end

