require 'sinatra'
require 'slim'
require 'hashids'

configure do
  enable :sessions
  hashids = Hashids.new( 'somesalt' ) #ENV[ 'HASHID_SALT' ] )
end

#helpers do
#end

get '/:redirect_code.?:format' do
  offer = hashids.decode( params[ :redirect_code ] )
  #offer = $redis.get( "direct_offer_#{ offer_id }" )
  json offer: offer
end
