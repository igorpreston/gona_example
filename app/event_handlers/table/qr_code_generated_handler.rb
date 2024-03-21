class Table::QrCodeGeneratedHandler < EventHandler
  on Table::Created

  def perform
    ActiveRecord::Base.transaction do
      create_qr! if table
    end
  end

  private

  def table
    @table ||= Table.lock.find(event.id)
  end

  def create_qr!
    table.create_qr_code(
      name: table.name,
      table_id: table.id,
      location_id: table.location_id
    )
  end
end
