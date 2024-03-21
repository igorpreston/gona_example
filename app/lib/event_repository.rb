class EventRepository
  include Singleton

  def subscribers
    @subscribers ||= {}
  end

  def notify_subscribers(event)
    Rails.logger.info "Publishing #{event.class.name} with params #{event.to_h}"

    subscribers[event.class.name].each do |subscriber|
      event_handler = subscriber.constantize

      record = EventRecord.create!(name: event.class.name, handler: subscriber, params: event.to_h)
      event.send(:assign_record, record)

      return if event.handled?

      if event_handler.async?
        EventWorker.perform_async(event.class.name, event.record.id, event.as_json, subscriber)
      else
        event_handler.new(event).perform
      end
    end
  end
end
