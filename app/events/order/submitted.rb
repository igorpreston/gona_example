class Order::Submitted < Event
  attribute :id, Types::Coercible::String
end
