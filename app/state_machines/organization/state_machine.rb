class Organization::StateMachine
  include Statesman::Machine

  state :onboarding, initial: true
  state :disabled
  state :active

  transition from: :onboarding, to: [:disabled, :active]
  transition from: :disabled, to: :active
  transition from: :active, to: :disabled

  guard_transition from: :onboarding, to: :disabled do |organization|
    organization.onboarding&.completed?
  end

  guard_transition from: :disabled, to: :active do |organization|
    organization.charges_enabled?
  end

  guard_transition from: :active, to: :disabled do |organization|
    organization.charges_enabled?
  end

  after_transition after_commit: true do |organization, transition|
    organization.update!(status: transition.to_state)
  end
end
