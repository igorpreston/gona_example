class Organization::StripeCustomerCreatedHandler < EventHandler
  on Organization::Created

  def perform_async
    Organization::CreateStripeCustomer.new(organization_id: event.id).perform
  end
end
