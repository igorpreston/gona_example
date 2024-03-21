class Order::StateMachine
  include Statesman::Machine

  state :draft, initial: true
  state :submitted
  state :in_progress
  state :ready
  state :completed
  state :cancelled
  state :ongoing

  transition from: :draft, to: %i[submitted ongoing cancelled]
  transition from: :submitted, to: %i[in_progress ready completed cancelled]
  transition from: :in_progress, to: %i[ready completed cancelled]
  transition from: :ready, to: :completed
  transition from: :ongoing, to: %i[completed cancelled]

  after_transition after_commit: true do |order, transition|
    order.update!(status: transition.to_state)
  end

  after_transition(to: :submitted) do |order|
    order.update(submitted_at: DateTime.current)
  end

  after_transition(to: :in_progress) do |order|
    order.update(in_progress_at: DateTime.current)
  end

  after_transition(to: :ready) do |order|
    order.update(ready_at: DateTime.current)
  end

  after_transition(to: :completed) do |order|
    order.update(completed_at: DateTime.current)
  end

  after_transition(to: :cancelled) do |order|
    order.update(cancelled_at: DateTime.current)
  end

  after_transition(to: :ongoing) do |order|
    order.update(submitted_at: DateTime.current)
  end
end
