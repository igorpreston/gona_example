class Item::Metadata
  include StoreModel::Model

  TEMPERATURES = {
    heated: 'heated',
    unheated: 'unheated',
    cold: 'cold'
  }.freeze

  # font awesome icons
  ICONS = {
    vegan: 'seedling',
    vegetarian: 'salad',
    gluten_free: 'wheat-slash',
    spicy: 'pepper-hot'
  }.freeze

  attribute :energy_cal, :integer, default: nil
  attribute :energy_kj, :integer, default: nil
  attribute :temperature, :string, default: nil
  attribute :vegan, :boolean, default: false
  attribute :vegetarian, :boolean, default: false
  attribute :gluten_free, :boolean, default: false
  attribute :spicy, :boolean, default: false

  validates :temperature, allow_nil: true, inclusion: { in: TEMPERATURES.keys }
  validates :energy_cal, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :energy_kj, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
end
