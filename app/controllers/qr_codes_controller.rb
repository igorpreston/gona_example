class QrCodesController < ApplicationController
  def index
    render locals: { qr_codes: }
  end

  def show
    render locals: { qr_code: }
  end

  def new
    qr_code = current_tenant.qr_codes.new

    render locals: { qr_code: }
  end

  def create
    qr_code = current_tenant.qr_codes.build(qr_code_params)

    if qr_code.save
      respond_to do |format|
        format.turbo_stream do
          render locals: { qr_code: }
        end
      end
    else
      render :new, locals: { qr_code: }
    end
  end

  private

  def qr_codes
    @pagy, @qr_codes = pagy(
      current_tenant.qr_codes.includes(
        :location, label_attachment: :blob
      ).order(created_at: :desc),
      items: 10
    )
  end

  def qr_code
    @qr_code ||= current_tenant.qr_codes.find(params[:id])
  end

  def qr_code_params
    params.require(:qr_code).permit(:name, :location_id)
  end
end
