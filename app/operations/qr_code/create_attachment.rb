class QrCode::CreateAttachment < Operation
  class Params < Operation::Params
    attribute :id, Types::Coercible::String
  end

  class Response < Operation::Response
    attribute :id, Types::Coercible::String
  end

  def perform
    qr_code = QrCode.find(params.id)
    qr_data = Rails.application.routes.url_helpers.qr_code_url(
      qr_code,
      protocol: ENV.fetch('PROTOCOL', 'https'),
      host: ENV.fetch('HOST', 'localhost:3000'),
      subdomain: 'order'
    )

    # Generate QR code using rqrcode_png gem
    qr = ::RQRCode::QRCode.new(qr_data)
    qr_image = generate_qr_image(qr)

    # Load brand logo image
    logo_image = load_logo_image

    # Calculate logo size and position
    logo_size = qr_image.width / 3
    logo_x = (qr_image.width - logo_size) / 2
    logo_y = (qr_image.height - logo_size) / 2

    # Resize and overlay logo on QR code
    qr_image = overlay_logo(qr_image, logo_image, logo_size, logo_x, logo_y)

    # Save and attach QR code image
    attach_qr_image(qr_code, qr_image)

    Response.new(id: qr_code.id)
  end

  private

  def generate_qr_image(qr)
    qr.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      module_px_size: 100,
      border_modules: 0,
      border: 0,
      shape_rendering: 'crispEdges',
      color: 'black',
      file: nil,
      fill: 'white'
    )
  end

  def load_logo_image
    logo_path = Rails.root.join('app', 'assets', 'images', 'qr_logo.png')
    ChunkyPNG::Image.from_file(logo_path)
  end

  def overlay_logo(qr_image, logo_image, logo_size, logo_x, logo_y)
    logo_resized = logo_image.resize(logo_size, logo_size)
    qr_image.compose!(logo_resized, logo_x, logo_y)
    qr_image
  end

  def attach_qr_image(qr_code, qr_image)
    file_name = "#{qr_code.prefix_id}.png"
    qr_code.label.attach(io: StringIO.new(qr_image.to_s), filename: file_name, content_type: 'image/png')
  end
end
