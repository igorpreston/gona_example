class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :template
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
