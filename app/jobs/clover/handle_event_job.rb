class Clover::HandleEventJob < ApplicationJob
  queue_as :clover

  def perform(event)
    handle_event(event)
  end

  private

  def handle_event(event)
    case event.data_type[0] # Assuming data_type starts with a letter indicating the event type
    when 'A'
      handle_app_event(event)
    when 'C'
      handle_customer_event(event)
      # Add cases for other types as needed
    end
  end

  def handle_app_event(event)
    # Implement logic for handling app events
  end

  def handle_customer_event(event)
    # Implement logic for handling customer events
  end

  # Implement other handlers as needed
end
