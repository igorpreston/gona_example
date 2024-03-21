# == Schema Information
#
# Table name: apps
#
#  id          :bigint           not null, primary key
#  description :text
#  metadata    :jsonb
#  name        :string           not null
#  published   :boolean          default(FALSE)
#  template    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class App < ApplicationRecord
  TEMPLATES = {
    'square' => Integration::Square,
    'clover' => Integration::Clover
  }.freeze

  has_prefix_id :app, minimum_length: 20

  has_many :integrations, dependent: :destroy

  validates :template, inclusion: { in: TEMPLATES.keys }
end
