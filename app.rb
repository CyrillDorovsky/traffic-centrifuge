require 'sinatra'
require './request_id_middleware'
require './request_information'
require 'hashids'
require 'fileutils'
require 'json'
require 'redis'
require 'bunny'
require './buyer_request'
require './direct_offer'

if Sinatra::Base.development?
  logger = ::File.open("log/development.log", "a+")
  STDOUT.reopen(logger)
  STDERR.reopen(logger)
  use Rack::CommonLogger, logger
end
use RequestIdMiddleware
use Rack::Session::Pool, :expire_after => 2592000

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
  
end

helpers do
end

get '/' do
  headers \
    "Content-Type" => "application/json"
  body JSON.generate( request_id: env['request_id'] )
end

get '/:redirect_code' do
  session[ :request_id ] = env['request_id'] 
  buyer_request = BuyerRequest.new( request, session, params )
  q = $bunny_channel.queue( "direct_offers" )
  q.publish buyer_request.visitor
  if buyer_request.acceptable
    redirect buyer_request.redirect_url
  else
    body JSON.generate( buyer_request.direct_offer.redis_record )
  end
end
