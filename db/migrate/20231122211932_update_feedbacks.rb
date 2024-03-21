# frozen_string_literal: true

# Migration to update feedbacks table
class UpdateFeedbacks < ActiveRecord::Migration[7.1]
  def up
    remove_column :feedbacks, :feedbackable_id
    remove_column :feedbacks, :feedbackable_type

    add_reference :feedbacks, :order_user, null: true, index: true
    add_reference :feedbacks, :order, null: true, index: true
    add_reference :feedbacks, :location, null: true, index: true

    change_column_null :feedbacks, :user_id, true
  end

  def down
    add_column :feedbacks, :feedbackable_id, :bigint
    add_column :feedbacks, :feedbackable_type, :string

    remove_reference :feedbacks, :order_user, null: true, index: true
    remove_reference :feedbacks, :order, null: true, index: true
    remove_reference :feedbacks, :location, null: true, index: true

    change_column :feedbacks, :user_id, :bigint, null: false
  end
end
