# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  handler    :string           not null
#  name       :string
#  params     :jsonb
#  state      :string           default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EventRecord < ApplicationRecord
  include ReadOnly

  self.table_name = 'events'

  attribute :name, :string
  attribute :state, :string
  attribute :params, :jsonb

  enum state: {
    pending: 'pending',
    handled: 'handled',
    failed: 'failed'
  }, _default: 'pending'

  def readonly?
    return false if will_save_change_to_attribute?(:state, from: 'pending', to: 'handled')
    return false if will_save_change_to_attribute?(:state, from: 'pending', to: 'failed')

    super
  end
end
