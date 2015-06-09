class DirectOffer
  attr_accessor :redis_offer

  def initialize( redirect_code )
    @redis_offer = pull_offer_from_redis
  end

  def for_message
    @redis_offer
  end

  def default_offer
    {}
  end


  def pull_offer_from_redis
    begin
      JSON.parse( $redis.get( "direct_offer_#{ redirect_code }" ) )
    rescue
      default_offer
    end
  end

end
