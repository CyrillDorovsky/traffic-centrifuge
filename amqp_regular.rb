require 'bunny'
class AmqpRegular
  def initialize( queue_name, message )
    bunny = Bunny.new ENV['CLOUDAMQP_URL']
    bunny.start
    bunny_channel  = bunny.create_channel
    regular_tasks = bunny_channel.queue( queue_name, durable: true )
    regular_tasks.publish message
  end
end
