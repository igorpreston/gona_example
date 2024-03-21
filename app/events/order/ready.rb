class Order::Ready < Event
  attribute :id, Types::Coercible::String
end
