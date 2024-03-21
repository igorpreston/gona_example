class Onboarding::State
  attr_reader :onboarding

  def initialize(onboarding)
    @onboarding = onboarding
  end

  def to_h
    state.to_h
  end
  alias_method :to_hash, :to_h

  private

  def state
    @state ||= tasks.each_with_object({}) do |task, state|
      state[task.name] = task.data
    end
  end
end
