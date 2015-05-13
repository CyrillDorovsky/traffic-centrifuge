require 'sinatra'
require 'haml'

$LOAD_PATH << '.'
require 'message'
require 'advert'

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
