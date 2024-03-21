# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  data       :jsonb            not null
#  data_type  :string
#  source     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Webhook < ApplicationRecord
  has_prefix_id :wh, minimum_length: 18

  enum source: {
    stripe: 'stripe',
    square: 'square',
    clover: 'clover'
  }

  validates :source, presence: true, inclusion: { in: sources.keys }
  validates :data_type, presence: true
  validates :data, presence: true
end
