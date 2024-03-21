module SquareClient
  def square_client(integration)
    ::Square::Client.new(
      access_token: integration.access_token,
      environment: ENV['SQUARE_ENVIRONMENT']
    )
  end
end
