class AddQrCodeToLogs < ActiveRecord::Migration[7.0]
  def change
    add_reference :logs, :qr_code, null: true
  end
end
