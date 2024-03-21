class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.belongs_to :organization, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.belongs_to :feedbackable, polymorphic: true, null: false, index: true
      t.text :content, null: false
      t.integer :rating, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
