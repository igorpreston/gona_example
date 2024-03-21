class AddFeedbacksCountToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :feedbacks_count, :integer, default: 0, null: false
    add_column :locations, :rating, :decimal, precision: 4, scale: 2, default: 0, null: false
  end
end
