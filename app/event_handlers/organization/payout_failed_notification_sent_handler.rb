class Organization::PayoutFailedNotificationSentHandler < EventHandler
  on Payout::Failed

  def perform_async
    Organization::PayoutFailedNotification.with(payout:).deliver(organization)
  end

  private

  def payout
    @payout ||= Payout.find(event.id)
  end

  def organization
    @organization ||= Organization.find(event.organization_id)
  end
end
