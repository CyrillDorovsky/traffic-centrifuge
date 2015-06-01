require 'sinatra'
require './request_id_middleware'
require 'hashids'
require 'json'
require 'redis'
require 'bunny'

use RequestIdMiddleware

configure do

  if ENV['REDISCLOUD_URL']
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    $redis = Redis.new( :host => uri.host, :port => uri.port, :password => uri.password )
  else
    $redis = Redis.new host: 'localhost', port: 6379
  end

  $bunny = Bunny.new ENV['CLOUDAMQP_URL']
  $bunny.start

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
  body env['request_id']
end

get '/:redirect_code' do
  q = $bunny.queue('direct_offers')
  offer = $redis.get( "direct_offer_#{ params[ :redirect_code ] }" )
  q.pubslish "#{ offer }"
  headers \
    "Content-Type" => "application/json"
  body JSON.parse( offer )
end
