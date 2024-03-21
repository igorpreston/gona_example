class CategoriesController < ApplicationController
  def index
    render locals: { categories: }
  end

  def show
    render locals: { category:, category_items: }
  end

  def new
    render locals: { category: Category.new }
  end

  def create
    category = Category.new(category_params)

    if category.save!
      redirect_to category_path(category), notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit
    render locals: { category: }
  end

  def update
    if category.update(category_params)
      redirect_to category_path(category), notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    category.destroy

    redirect_to categories_path, notice: 'Category was successfully destroyed.'
  end

  private

  def category_params
    params.require(:category).permit(:name, item_ids: [])
  end

  def categories
    @pagy, @categories = pagy(current_tenant.categories.includes(:menus).order(name: :asc), items: 20)
  end

  def category
    @category ||= Category.find(params[:id])
  end

  def category_items
    @category_items ||= category.category_items.includes(item: { photo_attachment: :blob }).order(position: :asc)
  end
end
