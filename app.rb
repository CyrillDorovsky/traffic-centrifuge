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
  $bunny_channel = $bunny.create_channel

  enable :sessions
end

helpers do
end

get '/' do
  headers \
    "Content-Type" => "application/json"
  body JSON.generate( request_id: env['request_id'] )
end

get '/:redirect_code' do
  q = $bunny_channel.queue('direct_offers')
  offer = $redis.get( "direct_offer_#{ params[ :redirect_code ] }" )
  q.publish "#{ offer }"
  headers \
    "Content-Type" => "application/json"
  body offer
end
