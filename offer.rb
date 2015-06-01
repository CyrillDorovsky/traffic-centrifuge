class Offer
  attr_accessor :redis_offer

  def initialize( redirect_code )
    @redis_offer = JSON.parse( $redis.get( "direct_offer_#{ redirect_code }" ) )
  end

  def for_message
    @redis_offer
  end
end
