require 'sinatra'
require './request_id_middleware'
require './request_information'
require 'hashids'
require 'json'
require 'redis'
require 'bunny'
require './buyer_request'
require './offer'

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
  q = $bunny_channel.queue('direct_offers')
  buyer_request = BuyerRequest.new( request, session, params )
  q.publish buyer_request.visitor
  if buyer_request.acceptable
    headers \
      "Content-Type" => "application/json"
    body "redirect_to #{ buyer_request.redirect_url }"
  else
    body ''
  end
end
