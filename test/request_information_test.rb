require File.expand_path '../../helpers/test_helper.rb', __FILE__
require File.expand_path '../request_information.rb', __FILE__

class RequestInformationTest < Minitest::Spec

  def setup
    super
    @ip_ru         = '217.118.82.88'
    @ip_de         = '5.83.128.0'
    @ip_us         = '206.17.20.75'
    @ip_unreadable = 'wrong_ip'
    @android       = 'Mozilla/5.0 (Android; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @linux         = 'Mozilla/5.0 (Linux; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @ipad          = 'Mozilla/5.0 (iPad; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @iphone        = 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @ipod          = 'Mozilla/5.0 (iPod; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @blackberry    = 'Mozilla/5.0 (Blackberry; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @windows       = 'Mozilla/5.0 (Windows; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @midp          = 'Mozilla/5.0 (midp; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
    @symbian       = 'Mozilla/5.0 (symbian; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
  end

  def test_show_attributes_parsing
  	request = double( remote_ip: @ip_ru, user_agent: @android )
  	allow( request ).to receive( :env ).and_return( Hash.new )
  	ru_request = RequestInformation.new( request )
    assert_equal ru_request.country, 'RU'
  end

end