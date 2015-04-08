require 'sinatra'

get '/hola' do
  android_version = request.user_agent[/Android (.*?);/]
  user_platform =  if android_version
                     "Android #{ $1 }"
                   else
                     "Android"
                   end
  erb :hola, locals: { user_platform: user_platform, app_url: 'http://mobile333.com/o/39168' }
end
