require 'clockwork'
require './amqp_regular'

include Clockwork

every( 2.minutes, 'Direct Offers to PG' ) { AmqpRegular.new( 'regular_tasks', 'import_direct_offers') }

if ENV['EMULATOR'] == 'ON'
every( 2.minutes, 'offer_set_show' ) { AmqpRegular.new( 'emulate_visitors', 'campaign_visitor' ) }
every( 2.minutes, 'offer_set_show' ) { AmqpRegular.new( 'emulate_visitors', 'offer_set_visitor' ) }
every( 2.minutes, 'offer_set_show' ) { AmqpRegular.new( 'emulate_visitors', 'direct_offer_visitor' ) }


every( 5.minutes, 'random conversion' ) { AmqpRegular.new( 'conversion_sender', 'mongo_offer_set_show' ) }
every( 10.minutes, 'random conversion' ) { AmqpRegular.new( 'conversion_sender', 'pg_offer_set_show' ) }
every( 10.minutes, 'random conversion' ) { AmqpRegular.new( 'conversion_sender', 'pg_direct_offer' ) }
end
