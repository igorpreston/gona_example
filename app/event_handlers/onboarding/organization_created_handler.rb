class Onboarding::OrganizationCreatedHandler < EventHandler
  on Organization::Created

  def perform
    organization_id = event.id

    Organization::CreateOnboarding.new(organization_id:).perform
  end
end
