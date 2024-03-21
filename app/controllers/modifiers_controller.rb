class ModifiersController < ApplicationController
  def index
    render locals: { modifiers: }
  end

  def show
    render locals: { modifier:, options: }
  end

  def new
    modifier = current_tenant.modifiers.new
    modifier.options.build.build_item

    render locals: { modifier: }
  end

  def create
    modifier = current_tenant.modifiers.build(modifier_params)

    if modifier.save!
      redirect_to modifier_path(modifier), notice: 'Modifier was successfully created.'
    else
      render :new
    end
  end

  def edit
    render locals: { modifier: }
  end

  def update
    if modifier.update!(modifier_params)
      redirect_to modifier_path(modifier), notice: 'Modifier was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if modifier.destroy
      redirect_to modifiers_path, notice: 'Modifier was successfully destroyed.'
    else
      render :edit
    end
  end

  private

  def modifier_params
    params.require(:modifier).permit(
      :name,
      :required,
      :min_select,
      :max_select,
      :max_option_select,
      options_attributes: [
        :id,
        :_destroy,
        { item_attributes: %i[id name price] }
      ]
    )
  end

  def modifiers
    @pagy, @modifiers = pagy(current_tenant.modifiers.order(name: :asc), items: 20)
  end

  def modifier
    @modifier = current_tenant.modifiers.find(params[:id])
  end

  def options
    @options ||= modifier.options&.includes(item: { photo_attachment: :blob }).order(position: :asc)
  end
end
