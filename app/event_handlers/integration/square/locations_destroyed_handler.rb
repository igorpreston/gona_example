class Integration::Square::LocationsDestroyedHandler < EventHandler
  on Integration::Square::Destroyed

  def perform_async
    organization.locations.where.not(square_id: nil).each(&:destroy)
  end

  private

  def organization
    @organization ||= Organization.find(event.organization_id)
  end
end
