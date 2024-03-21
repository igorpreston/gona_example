class Storefront::QrCodesController < Storefront::BaseController
  def show
    log_scanned_qr_code(qr_code)

    if qr_code.table_id.present?
      redirect_to table_path(qr_code.table, subdomain: nil)
    else
      redirect_to location_path(qr_code.location, subdomain: nil)
    end
  end

  private

  def qr_code
    @qr_code ||= QrCode.find(params[:id])
  end

  def log_scanned_qr_code(qr_code)
    qr_code.logs.create!(
      qr_code:,
      message_key: Log::MESSAGE_KEYS[:qr_code_scanned],
      scope: 'internal',
      data: {
        user_agent: request.user_agent,
        ip_address: request.remote_ip,
        referer: request.referer
      }
    )
  end
end
