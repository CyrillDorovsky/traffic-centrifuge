require 'useragent'

class BuyerRequest
  attr_accessor :request, :session, :redirect_url

  def initialize( request, session, params = {} )
    @redirect_url = params[ :redirect_code ]
    @redis   = offer_from_redis( @redirect_url )
    @request = RequestInformation.new( request )
    @session = session
    @request_id = session[ 'request_id' ]
    @offer = Offer.new( params[ 'redirect_code' ] )
  end

  def visitor
    JSON.generate( offer: @offer.for_message, request: @request.for_message, event: 'visitor' )
  end

  def acceptable
    true
  end

  def redirect_url
    @redis[ 'seller_url' ].gsub( 'aff_sub=', "aff_sub=#{ @request_id }" )
  end

  def offer_from_redis( id )
    raw_redis = $redis.get( "direct_offer_#{ id }" )
    raw_redis ? JSON.parse( raw_redis ) : raw_redis
  end

end
