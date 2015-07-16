require 'useragent'

class BuyerRequest
  
  attr_accessor :request, :session, :redirect_url, :direct_offer, :dealer_id, :url_query, :params

  def initialize( request, session, params = {} )
    @params = params
    @request = RequestInformation.new( request )
    @direct_offer = DirectOffer.new( params[ 'redirect_code' ] )
    @redirect_url = modify_url_with_uniq_iq( @direct_offer )
    @dealer_id = @direct_offer.dealer_id
    @url_query = @request.url_query
  end

  def visitor
    JSON.generate( from: @direct_offer.redirect_code, offer: @direct_offer.for_message, request: @request.for_message, event: 'direct_offer_show', params: @params )#url_query: @url_query,
  end

  def redirect
    JSON.generate( from: @direct_offer.redirect_code, offer: @direct_offer.for_message, request: @request.for_message, redirect_url: @redirect_url, event: 'direct_offer_redirect', params: @params )
  end

  def trafback
    JSON.generate( offer: @direct_offer.for_message, request: @request.for_message, url_query: @url_query, event: 'trafback' )
  end

  def acceptable
    @direct_offer.redis_record['enabled'] & @direct_offer.redis_record['approved']
  end

  def check_platform
    @request.user_platform == @direct_offer.redis_record['apps_os']
  end

  def check_country
    country_from_redis( @request.country ).include?( @direct_offer.redis_record['offer_id'] )
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

  def queue_id
  end

  def modify_url_with_uniq_iq( seller_url )
    uniq_id = @request.env['request_id'] 
    direct_offer.redis_record[ 'seller_url' ].gsub( 'mongo_id', uniq_id )
  end
end
