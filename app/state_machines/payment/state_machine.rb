class Payment::StateMachine
  include Statesman::Machine

  state :created, initial: true
  state :uncaptured
  state :paid
  state :partially_refunded
  state :refunded
  state :failed
  state :cancelled

  transition from: :created, to: %i[uncaptured paid partially_refunded refunded failed cancelled]
  transition from: :uncaptured, to: %i[paid partially_refunded refunded failed cancelled]
  transition from: :paid, to: %i[partially_refunded refunded failed]
  transition from: :partially_refunded, to: %i[refunded failed]
  transition from: :refunded, to: %i[failed]
  transition from: :failed, to: %i[uncaptured paid partially_refunded refunded cancelled]

  after_transition after_commit: true do |payment, transition|
    payment.update!(status: transition.to_state)
  end
end
