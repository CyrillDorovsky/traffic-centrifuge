require 'bunny'
class AmqpRegular
  def initialize( message )
    bunny = Bunny.new ENV['CLOUDAMQP_URL']
    bunny.start
    bunny_channel  = bunny.create_channel
    regular_tasks = bunny_channel.queue( "regular_tasks", durable: true )
    regular_tasks.publish message
  end
end
