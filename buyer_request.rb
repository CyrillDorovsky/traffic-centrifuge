require 'useragent'

class BuyerRequest
  attr_accessor :request, :session, :redirect_url, :acceptable

  def initialize( request, session, params = {} )
    @redirect_url     = params[ :redirect_code ]
    @redis            = offer_from_redis( @redirect_url )
    @request = RequestInformation.new( request )
    @session = session
    @request_id = session[ 'request_id' ]
    @offer = Offer.new( params[ :redirect_code ] )
  end

  def visitor
    JSON.generate( offer: @offer.for_message, request: @request.for_message, event: 'visitor' )
  end

  def acceptable
    check_platform & check_country & @redis['enabled'] & @redis['approved']
  end

  def redirect_url
    @redis['seller_url'].gsub( 'aff_sub=', "aff_sub=#{ @request_id }" )
  end

  def check_platform
    @request.user_platform == @redis['apps_os']
  end

  def check_country
    country_from_redis( @request.country ).include?( @redis['offer_id'] )
  end

  def country_from_redis( abbr )
    if abbr
      country_redis_string = $redis.get "country_offers_#{ abbr }"
      filter_result_offer_set = ( country_redis_string != nil ) ? JSON.parse( country_redis_string ) : []
    end
    filter_result_offer_set = filter_result_offer_set + JSON.parse( $redis.get "country_offers_ALL" )
  end

  def offer_from_redis( id )
    raw_redis = $redis.get( "direct_offer_#{ id }" )
    raw_redis ? JSON.parse( raw_redis ) : raw_redis
  end

end
