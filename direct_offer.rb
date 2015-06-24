class DirectOffer
  attr_accessor :redis_record, :redirect_url, :dealer_id, :redirect_code

  def initialize( redirect_code )
    @redirect_code = redirect_code
    @redis_record = pull_offer_from_redis
    @dealer_id = @redis_record[ 'dealer_id' ]
  end

  def pull_offer_from_redis
    begin
      JSON.parse( $redis.get( "direct_offer_#{ @redirect_code }" ) )
    rescue
      default_offer
    end
  end

  def default_offer
    JSON.parse( $redis.get( "direct_offer_0zuO6" ) )
  end

  def for_message
    @redis_record
  end

end
