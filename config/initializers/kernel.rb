module Kernel
  def publish_event(event_klass, **kwargs)
    event = event_klass.new(kwargs)

    event.publish!
  end
end
