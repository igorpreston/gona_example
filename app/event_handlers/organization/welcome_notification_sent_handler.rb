class Organization::WelcomeNotificationSentHandler < EventHandler
  on Organization::Created

  def perform_async
    Organization::WelcomeNotification.with(organization:).deliver(organization)
  end

  private

  def organization
    @organization ||= Organization.find(event.id)
  end
end
