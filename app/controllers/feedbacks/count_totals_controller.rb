class Feedbacks::CountTotalsController < ApplicationController
  def show
    render layout: false, locals: { total: }
  end

  private

  def total
    total = current_tenant.feedbacks
    total.size
  end
end
