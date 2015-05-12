require 'sinatra'
require 'haml'

$LOAD_PATH << '.'
require 'message'
require 'advert'

get '/' do
  haml :index, locals: { messages: Message.index, apps_list: Advert.apps }
end

get '/apps' do
  haml :index, locals: { messages: Message.index, apps_list: Advert.apps }
end

get '/games' do
  haml :index, locals: { messages: Message.index, apps_list: Advert.apps }
end


get '/lazy' do
  haml :lazy, locals: { lazy: Advert.apps[ :lazy ] }
end
