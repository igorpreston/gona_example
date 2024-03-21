class Payout::PaidNotificationHandler < EventHandler
  on Payout::Paid

  def perform_async
    Organization::PayoutPaidNotification.with(payout:).deliver(organization)
  end

  private

  def payout
    Payout.lock.find(event.id)
  end

  def organization
    payout.organization
  end
end
