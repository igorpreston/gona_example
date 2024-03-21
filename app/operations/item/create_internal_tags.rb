class Item::CreateInternalTags < Operation
  class Params < Operation::Params
    attribute :id, Types::Coercible::String
  end

  class Response < Operation::Response
    attribute :id, Types::Coercible::String
  end

  def perform
    item.update!(internal_tags: create_internal_tags!)

    { id: item.id }
  end

  private

  def item
    @item ||= Item.find(params.id)
  end

  def client
    @client ||= OpenAI::Client.new
  end

  def client_response
    @response ||= client.completions(
      parameters: {
        model: 'text-davinci-001',
        prompt: "Generate tags for #{item.name} that will help to boost search:",
        max_tokens: 300,
        stop: nil,
        temperature: 0.7
      }
    )
  rescue OpenAI::Error => e
    Rails.logger.error "[#{self.class.name}##{__method__}] #{e.message}"
  end

  def create_internal_tags!
    client_response.dig('choices', 0, 'text').scan(/[a-zA-Z\s]+/).map(&:strip).reject(&:empty?)
  end
end
