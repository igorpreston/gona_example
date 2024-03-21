# == Schema Information
#
# Table name: operations
#
#  id         :bigint           not null, primary key
#  name       :string
#  params     :jsonb
#  response   :jsonb
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class OperationRecord < ApplicationRecord
  # include ReadOnly

  self.table_name = 'operations'

  attribute :name, :string
  attribute :status, :string
  attribute :params, :jsonb
  attribute :response, :jsonb
end
