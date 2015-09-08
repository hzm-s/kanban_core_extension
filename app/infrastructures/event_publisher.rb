require 'singleton'

class EventPublisher
  include Singleton
  include Wisper::Publisher

  class << self

    def publish(name, event)
      instance.publish(name, event)
    end
  end

  def publish(name, event)
    broadcast(name, event)
  end
end
