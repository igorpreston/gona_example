class UpdateContentOnFeedbacks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :feedbacks, :content, true
  end
end
