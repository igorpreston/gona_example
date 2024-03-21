# == Schema Information
#
# Table name: feedbacks
#
#  id              :bigint           not null, primary key
#  content         :text
#  deleted_at      :datetime
#  notify          :boolean          default(FALSE)
#  rating          :integer          not null
#  response        :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :bigint
#  order_id        :bigint
#  order_user_id   :bigint
#  organization_id :bigint           not null
#  user_id         :bigint
#
# Indexes
#
#  index_feedbacks_on_deleted_at       (deleted_at)
#  index_feedbacks_on_location_id      (location_id)
#  index_feedbacks_on_order_id         (order_id)
#  index_feedbacks_on_order_user_id    (order_user_id)
#  index_feedbacks_on_organization_id  (organization_id)
#  index_feedbacks_on_user_id          (user_id)
#
class Feedback < ApplicationRecord
  MIN_RATING = 0
  MAX_RATING = 5

  has_prefix_id :fdb, minimum_length: 18

  acts_as_tenant :organization

  after_commit :publish_created!, on: :create
  after_commit :update_location_rating!, on: :create, if: -> { location.present? }
  after_commit :publish_response_created!, on: :update, if: -> { saved_change_to_response? && notify? }

  belongs_to :user, optional: true
  belongs_to :order_user, optional: true
  belongs_to :order, optional: true
  belongs_to :location, optional: true

  counter_culture :organization, column_name: 'feedbacks_count'
  counter_culture :location, column_name: 'feedbacks_count'

  validates :rating, presence: true, numericality: {
    only_integer: true, greater_than_or_equal_to: MIN_RATING, less_than_or_equal_to: MAX_RATING
  }

  private

  def publish_created!
    publish_event Feedback::Created, id:
  end

  def publish_response_created!
    publish_event Feedback::ResponseCreated, id:
  end

  def update_location_rating!
    location.update_rating!
  end
end
