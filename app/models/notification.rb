# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  params         :jsonb
#  read_at        :datetime
#  recipient_type :string           not null
#  type           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipient_id   :bigint           not null
#
# Indexes
#
#  index_notifications_on_read_at    (read_at)
#  index_notifications_on_recipient  (recipient_type,recipient_id)
#
class Notification < ApplicationRecord
  include Noticed::Model

  has_prefix_id :ntf, minimum_length: 18

  belongs_to :recipient, polymorphic: true

  # counter_culture :recipient, column_name: ->(model) { model.read_at.nil? ? 'unread_notifications_count' : nil }
end
