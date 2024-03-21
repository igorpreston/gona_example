class CreateSuggestions < ActiveRecord::Migration[7.0]
  def change
    create_table :suggestions do |t|
      t.references :user, null: false, index: true
      t.text :description
      t.string :referer

      t.timestamps
    end
  end
end
