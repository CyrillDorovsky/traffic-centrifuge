require 'sinatra'
require 'haml'

$LOAD_PATH << '.'
require 'message'

get '/' do
  haml :index, locals: { messages: Message.index, link_to_best_app: 'http://target.xeclick.com/o/39168' }
end
