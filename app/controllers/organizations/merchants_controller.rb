class Organizations::MerchantsController < ApplicationController
  def index
    render locals: { merchants:, owner: }
  end

  def new; end

  def create
    merchant = Merchant.invite!(new_merchant_params.merge(organization: current_tenant), current_merchant)

    respond_to do |format|
      format.turbo_stream do
        render locals: { merchant: }
      end
    end
  end

  def destroy
    current_tenant.merchants.delete(merchant)

    respond_to do |format|
      format.turbo_stream do
        render locals: { merchant: }
      end
    end
  end

  private

  def new_merchant_params
    params.require(:merchant).permit(:first_name, :last_name, :email)
  end

  def merchant
    @merchant ||= current_tenant.merchants.find(params[:id])
  end

  def merchants
    @pagy, @merchants = pagy(
      current_tenant.merchants.where.not(role: :owner).includes(avatar_attachment: :blob),
      items: 20
    )
  end

  def owner
    @owner ||= current_tenant.owner
  end
end
