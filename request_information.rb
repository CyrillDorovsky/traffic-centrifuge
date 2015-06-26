require 'geoip'
class RequestInformation

  attr_accessor :referrer, :ip, :country, :user_agent, :user_platform, :locale, :env, :url_query

  def initialize( request )
    @user_agent    = request.user_agent
    @ip            = RequestInformation.read_ip( request )
    @referrer      = request.referrer
    @country       = get_country( request )
    @user_platform = get_platform( request )
    @locale        = get_locale( request )
    @env           = request.env
  end

  def get_locale( request )
    locale = request.env[ 'HTTP_ACCEPT_LANGUAGE' ]
    if locale
      locale.scan(/^[a-z]{2}/).first
    else
      'en'
    end
  end

  def self.message_l10n( translations_hash={}, preferred_locale='' )
    translations_hash[ preferred_locale ] || translations_hash[ 'default' ]
  end

  def self.is_ru_mobile?( request )
    request_ip = read_ip( request )
    ( BeelineIps.ip_list + MtsIps.ip_list + MegafonIps.ip_list ).include?( request_ip )
  end

  def get_country( request )
    country = country_by_ip( @ip )
    country = ( country == 'N/A' ) ? country : country.country_code2
    country = ( country == '--' ) ? 'N/A' : country
  end

  def get_platform( request )
    parsed_platform = UserAgent.parse( request.user_agent ).platform.downcase
    case parsed_platform
    when 'ipad'
      'ipad'
    when 'iphone', 'ipod'
      'ipod_iphone'
    when 'android', 'linux'
      'android'
    when 'blackberry', 'windows'
      'mobile'
    else 
      if !request.user_agent.nil?
        request.user_agent.downcase[/midp|symbian/] ? 'mobile' : 'pc'
      else
        'pc'
      end
    end
  end

  def self.read_ip( request )
    request_masked = request.env[ 'HTTP_X_FORWARDED_FOR' ]
    request_masked ? request_masked.split(',').first : request.ip
  end

  def country_by_ip( ip )
    begin
      country = GeoIP.new( 'lib/geoip/GeoIP.dat' ).country( ip )
    rescue SocketError
      country = 'N/A'
    end
    country
  end

  def for_message
    { referrer: @referrer,
      ip: @ip,
      request_id: @env['request_id'],
      country: @country,
      user_agent: @user_agent,
      user_platform: @user_platform,
      timestamp: Time.new.to_i.to_s,
      locale: @locale }
  end
end
