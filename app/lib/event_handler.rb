class EventHandler
  attr_reader :event

  def initialize(event = nil)
    @event = event

    if self.class.public_instance_methods.include?(:perform)
      self.class.prepend(PerformOverrides)
    elsif self.class.public_instance_methods.include?(:perform_async)
      self.class.prepend(PerformAsyncOverrides)
    end
  end

  def self.inherited(base)
    base.extend(ClassMethods)
  end

  module PerformOverrides
    def perform(*)
      begin
        super(*)
        event.handled!
      rescue StandardError
        event.failed!
      end
    end
  end

  module PerformAsyncOverrides
    def perform_async(*)
      begin
        super(*)
        event.handled!
      rescue StandardError
        event.failed!
      end
    end
  end

  module ClassMethods
    def on(*events)
      events.each do |event|
        next if subscribed?(event)

        event.subscribe(self)
      end
    end

    def async?
      public_instance_methods.include?(:perform_async)
    end

    def subscribed?(event)
      EventRepository.instance.subscribers.fetch(event.to_s, []).include?(to_s)
    end
  end
end
