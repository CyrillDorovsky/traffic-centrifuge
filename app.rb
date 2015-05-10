require 'sinatra'
require 'haml'

$LOAD_PATH << '.'
require 'message'
require 'advert'

get '/' do
  haml :index, locals: { messages: Message.index, apps_list: Advert.apps_list }
end
