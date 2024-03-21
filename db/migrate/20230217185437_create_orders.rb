class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :status, null: false
      t.string :preference, null: false
      t.string :platform, null: false
      t.string :number, unique: true, null: true
      t.string :tracking_token, unique: true, null: true
      t.integer :preparation_time_seconds, null: false, default: 0
      t.datetime :scheduled_for
      t.datetime :submitted_at
      t.datetime :in_progress_at
      t.datetime :ready_at
      t.datetime :completed_at
      t.datetime :cancelled_at
      t.integer :items_count, null: false, default: 0
      t.integer :payments_count, null: false, default: 0
      t.integer :feedbacks_count, null: false, default: 0
      t.belongs_to :organization, null: false, index: true
      t.belongs_to :location, null: false, index: true
      t.belongs_to :user, null: true, index: true

      t.timestamps
    end
  end
end
