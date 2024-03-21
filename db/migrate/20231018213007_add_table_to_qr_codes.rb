class AddTableToQrCodes < ActiveRecord::Migration[7.0]
  def change
    add_reference :qr_codes, :table, index: true, null: true
  end
end
