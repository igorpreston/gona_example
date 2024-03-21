class CreateOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :operations do |t|
      t.string :name
      t.string :status
      t.jsonb :params
      t.jsonb :response

      t.timestamps
    end
  end
end
