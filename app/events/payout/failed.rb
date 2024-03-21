class Payout::Failed < Event
  attribute :id, Types::Coercible::String
  attribute :organization_id, Types::Coercible::String
end
