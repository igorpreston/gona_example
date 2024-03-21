class ItemsController < ApplicationController
  def index
    render locals: { items: }
  end

  def show
    render locals: { item: }
  end

  def new
    render locals: { item: current_tenant.items.new(source: 'catalog') }
  end

  def create
    item = current_tenant.items.new(item_params)
    item.source = :catalog

    if item.save!
      redirect_to items_path, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def edit
    render locals: { item: }
  end

  def update
    if item.update(item_params)
      redirect_to items_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if item.destroy
      redirect_to items_path, notice: 'Item was successfully destroyed.'
    else
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :price,
      :photo,
      :description,
      metadata: %i[
        energy_cal
        energy_kj
        temperature
        vegan
        vegetarian
        gluten_free
        spicy
      ],
      category_ids: [],
      modifier_ids: []
    )
  end

  def items
    @pagy, @items = pagy(
      current_tenant.items.includes(
        photo_attachment: :blob
      ).where(
        source: 'catalog'
      ).order(name: :asc),
      items: 20
    )
  end

  def item
    @item ||= current_tenant.items.find(params[:id])
  end
end
