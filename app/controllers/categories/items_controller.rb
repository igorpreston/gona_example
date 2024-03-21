class Categories::ItemsController < ApplicationController
  def show
    results = current_tenant.items.where(
      'name ILIKE ? AND source = ?', "%#{params[:query]}%", 'catalog'
    ).includes(photo_attachment: :blob).where.not(
      id: category.items&.pluck(:id)
    ).order(:name)

    @pagy, @items = pagy(results, items: 5)

    render locals: { category:, items: @items }
  end

  private

  def category
    @category ||= current_tenant.categories.find(params[:category_id])
  end
end
