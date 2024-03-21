class Payment::Refunded < Event
  attribute :id, Types::Coercible::String
end
