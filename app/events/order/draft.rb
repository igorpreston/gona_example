class Order::Draft < Event
  attribute :id, Types::Coercible::String
end
