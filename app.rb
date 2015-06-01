require 'sinatra'
require 'hashids'
require 'json'
require 'redis'

configure do

  if ENV['REDISCLOUD_URL']
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    $redis = Redis.new( :host => uri.host, :port => uri.port, :password => uri.password )
  else
    $redis = Redis.new host: 'localhost', port: 6379
  end

  enable :sessions
end

helpers do
  def hashid
    Hashids.new( 'richpays number one' ) #ENV[ 'HASHID_SALT' ] )
  end
end

get '/' do
  root_opts = { redorect_code: hashid.encode( ) }
  headers \
    "Content-Type" => "application/json"
  body JSON.generate( root_opts )
end

get '/:redirect_code' do
  offer = $redis.get( "direct_offer_#{ params[ :redirect_code ] }" )
  headers \
    "Content-Type" => "application/json"
  body offer
end
