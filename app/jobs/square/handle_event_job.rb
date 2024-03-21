class Square::HandleEventJob < ApplicationJob
  queue_as :square

  def perform(event)
    handle_event(event)
  end

  private

  def handle_event(event)
    case event.data_type
    when 'oauth.authorization.revoked'
      handle_oauth_authorization_revoked(event)
    when 'location.created'
      handle_location_created(event)
    when 'location.updated'
      handle_location_updated(event)
    when 'order.created'
      handle_order_created(event)
    when 'order.fulfillment.updated'
      handle_order_fulfillment_updated(event)
    when 'catalog.version.updated'
      handle_catalog_version_updated(event)
    end
  end

  def handle_oauth_authorization_revoked(event)
    Square::OauthAuthorizationRevokedWebhook.new.call(event)
  end

  def handle_location_created(event)
    Square::LocationCreatedOrUpdatedWebhook.new.call(event)
  end

  def handle_location_updated(event)
    Square::LocationCreatedOrUpdatedWebhook.new.call(event)
  end

  def handle_order_created(event)
    Square::OrderCreatedWebhook.new.call(event)
  end

  def handle_order_fulfillment_updated(event)
    Square::OrderFulfillmentUpdatedWebhook.new.call(event)
  end

  def handle_catalog_version_updated(event)
    Square::CatalogVersionUpdatedWebhook.new.call(event)
  end
end
