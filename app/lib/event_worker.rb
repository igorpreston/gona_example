class EventWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'event_handlers'

  def perform(event_klass, event_record_id, event_payload, event_handler_klass)
    event = Event.from(event_klass, event_payload, event_record_id)

    return if event.handled?

    event_handler = event_handler_klass.constantize.new(event)

    logger.info "#{event_handler_klass} handling #{event_klass} with id #{event_record_id} with params #{event_payload.to_h}"

    event_handler.perform_async
  end
end
