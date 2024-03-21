class Order::InProgress < Event
  attribute :id, Types::Coercible::String
end
