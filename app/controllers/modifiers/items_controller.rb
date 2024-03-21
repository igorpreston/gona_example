class Modifiers::ItemsController < ApplicationController
  def show
    render locals: { modifier:, items: }
  end

  private

  def modifier
    @modifier ||= current_tenant.modifiers.find(params[:modifier_id])
  end

  def items
    @pagy, @items = pagy(modifier.items.order(:name), items: 5)
  end
end
