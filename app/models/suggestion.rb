# == Schema Information
#
# Table name: suggestions
#
#  id          :bigint           not null, primary key
#  data        :jsonb            not null
#  description :text
#  referer     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  merchant_id :bigint
#  user_id     :integer
#
# Indexes
#
#  index_suggestions_on_merchant_id  (merchant_id)
#  index_suggestions_on_user_id      (user_id)
#
class Suggestion < ApplicationRecord
  has_prefix_id :sug, minimum_length: 18

  belongs_to :user, optional: true
  belongs_to :merchant, optional: true

  validates :description, presence: true
end
