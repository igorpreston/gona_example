class Onboarding::CompletedHandler < EventHandler
  on Onboarding::Completed

  def perform
    onboarding.update!(completed_at: DateTime.current, status: :completed)

    state = onboarding.organization&.charges_enabled? ? :active : :disabled
    onboarding.organization.state_machine.transition_to!(state)
  end

  private

  def onboarding
    @onboarding ||= Onboarding.find(event.id)
  end
end
