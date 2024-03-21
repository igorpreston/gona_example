# == Schema Information
#
# Table name: subscriptions
#
#  id                     :bigint           not null, primary key
#  canceled_at            :datetime
#  ends_at                :datetime
#  interval               :string
#  quantity               :integer
#  status                 :string
#  trial_ends_at          :datetime
#  trial_starts_at        :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  organization_id        :bigint
#  stripe_customer_id     :string
#  stripe_plan_id         :string
#  stripe_subscription_id :string
#
# Indexes
#
#  index_subscriptions_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Subscription < ApplicationRecord
  has_prefix_id :sub, minimum_length: 12

  belongs_to :organization, touch: true

  def active?
    status == 'active'
  end

  def cancelled?
    status == 'canceled'
  end
end
