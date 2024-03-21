class Order::Created < Event
  attribute :id, Types::Coercible::String
end
