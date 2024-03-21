class Item::InternalTagsCreatedHandler < EventHandler
  on Item::Created

  def perform_async
    Item::CreateInternalTags.new(id: event.id).perform if Rails.env.production?
  end
end
