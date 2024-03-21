module ReadOnly
  extend ActiveSupport::Concern

  included do
    before_destroy { raise ActiveRecord::ReadOnlyRecord.new("#{self.class.name} is marked as readonly") }

    def readonly?
      !new_record?
    end
  end
end
