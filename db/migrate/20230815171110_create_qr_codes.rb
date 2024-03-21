class CreateQrCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_codes do |t|
      t.references :organization, null: false, foreign_key: true, index: true
      t.references :location, null: true, index: true
      t.string :code, unique: true, null: true
      t.string :name, null: true

      t.timestamps
    end
  end
end
