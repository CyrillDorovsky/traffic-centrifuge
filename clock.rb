require 'clockwork'
require './amqp_regular'

include Clockwork

if ENV['EMULATOR'] == 'ON'
every( 1.second, 'offer_set_show' ) { AmqpRegular.new( 'emulate_visitors', 'campaign_visitor' ) }
every( 1.second, 'offer_set_show' ) { AmqpRegular.new( 'emulate_visitors', 'offer_set_visitor' ) }
every( 1.second, 'offer_set_show' ) { AmqpRegular.new( 'emulate_visitors', 'direct_offer_visitor' ) }

every( 10.seconds, 'random conversion' ) { AmqpRegular.new( 'conversion_sender', 'mongo_offer_set_show' ) }
every( 10.seconds, 'random conversion' ) { AmqpRegular.new( 'conversion_sender', 'pg_offer_set_show' ) }
every( 10.seconds, 'random conversion' ) { AmqpRegular.new( 'conversion_sender', 'pg_direct_offer' ) }
end
