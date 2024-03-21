class Order::Cancelled < Event
  attribute :id, Types::Coercible::String
end
