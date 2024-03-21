class UsersController < ApplicationController
  def show
    render locals: { user: }
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
end
