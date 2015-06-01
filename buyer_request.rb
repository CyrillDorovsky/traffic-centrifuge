require 'useragent'

class BuyerRequest
  attr_accessor :request, :session, :redirect_url

  def initialize( request, session, params = {} )
    @request = RequestInformation.new( request )
    @session = session
    @offer = Offer.new( params[ 'redirect_code' ] )
  end

  def visitor
    JSON.generate( offer: @offer.for_message, request: @request.for_message, event: 'visitor' )
  end

  def acceptable
    true
  end

  def redirect_url
    provider_url_generator = @offer.seller_url
    target_url = eval( provider_url_generator )
    target_url
  end

end
