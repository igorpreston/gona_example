Rails.application.config.to_prepare do
  Dir.glob(Rails.root.join('app', 'event_handlers', '**', '*.rb'), &method(:require))
end
