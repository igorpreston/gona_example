class AddFieldsToFeedbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :feedbacks, :notify, :boolean, default: false
    add_column :feedbacks, :response, :text
  end
end
