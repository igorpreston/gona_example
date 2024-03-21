class Modifiers::OptionsController < ApplicationController
  def new
    option = Option.new(modifier:)
    option.build_item

    render locals: { option:, modifier: }
  end

  def create
    option = current_tenant.options.new(option_params.merge(modifier:))
    option.item.modifier!

    if option.save!
      redirect_to modifier_path(modifier), notice: 'Option created successfully'
    else
      render :new
    end
  end

  def edit
    render locals: { option:, modifier: }
  end

  def update
    @option = Option.find(params[:id])

    if @option.update(option_params)
      redirect_to modifier_path(modifier), notice: 'Option updated successfully'
    else
      render :edit
    end
  end

  private

  def option_params
    params.require(:option).permit(:item_id, item_attributes: %i[id name price])
  end

  def modifier
    @modifier ||= current_tenant.modifiers.find(params[:modifier_id])
  end

  def option
    @option ||= modifier.options.find(params[:id])
  end
end
