class Location::QrCodeGeneratedHandler < EventHandler
  on Location::Created

  def perform
    ActiveRecord::Base.transaction do
      create_qr! if location
    end
  end

  private

  def location
    @location ||= Location.lock.find(event.id)
  end

  def create_qr!
    location.create_qr_code(
      name: location.name,
      organization: location.organization
    )
  end
end
