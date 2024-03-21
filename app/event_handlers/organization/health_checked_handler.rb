class Organization::HealthCheckedHandler < EventHandler
  on Organization::HealthChecked

  def perform
    organization.state_machine.transition_to!(
      organization.charges_enabled? ? :active : :disabled
    )
  end

  private

  def organization
    @organization ||= Organization.find(event.id)
  end
end
