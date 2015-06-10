class DirectOffer
  attr_accessor :redis_record, :redirect_url, :dealer_id

  def initialize( redirect_code )
    @redirect_code = redirect_code
    @redis_record = pull_offer_from_redis
    @dealer_id = @redis_record[ 'dealer_id' ]
  end

  def pull_offer_from_redis
    JSON.parse( $redis.get( "direct_offer_#{ @redirect_code }" ) )
  end

  def default_offer
    { 'seller_url' => 'http://google.com/aff_sub=' }
  end

  def for_message
    @redis_record
  end

end
