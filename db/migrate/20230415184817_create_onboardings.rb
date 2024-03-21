class CreateOnboardings < ActiveRecord::Migration[7.0]
  def change
    create_table :onboardings do |t|
      t.belongs_to :organization, null: true, index: true
      t.string :status, null: false, default: 'active'
      t.integer :tasks_count, null: false, default: 0
      t.integer :completed_tasks_count, null: false, default: 0
      t.datetime :completed_at

      t.timestamps
    end
  end
end
