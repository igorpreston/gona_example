class Feedbacks::CountRepliesController < ApplicationController
  def show
    render layout: false, locals: { total: 0 }
  end
end
