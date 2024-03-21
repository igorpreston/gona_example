class Menus::PublishesController < ApplicationController
  def update
    if menu.update!(published: params[:published])
      redirect_to menu_path(menu), notice: "Menu was successfully #{menu.published? ? 'published' : 'unpublished'}"
    else
      redirect_to menu_path(menu), alert: 'Menu was not updated.'
    end
  end

  private

  def menu
    @menu ||= Menu.find(params[:menu_id])
  end
end
