require 'clockwork'
require './amqp_regular'

include Clockwork

every( 1.minute, 'random conversion' ) { AmqpRegular.new( 'random_conversion' ) }
