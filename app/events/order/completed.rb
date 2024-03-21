class Order::Completed < Event
  attribute :id, Types::Coercible::String
end
