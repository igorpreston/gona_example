class QrCode::AttachmentCreatedHandler < EventHandler
  on QrCode::Created

  def perform_async
    QrCode::CreateAttachment.new(id: event.id).perform
  end
end
