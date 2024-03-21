class Event < Dry::Struct
  transform_keys(&:to_sym)

  attr_reader :record

  delegate :handled!, :failed!, to: :record
  delegate :state, :pending?, :handled?, :failed, to: :record, allow_nil: true

  def to_s
    self.class.name
  end

  def publish!
    self.class.repository.notify_subscribers(self)
  end

  def self.inherited(base)
    base.extend(ClassMethods)

    super
  end

  def self.from(klass, payload, record_id)
    record = EventRecord.find(record_id)

    klass.constantize.new(payload.to_h).tap do |event|
      event.send(:assign_record, record)
    end
  end

  def self.repository
    @repository ||= EventRepository.instance
  end

  module ClassMethods
    def subscribers
      repository.subscribers[to_s]
    end

    def subscribe(handler)
      repository.subscribers[to_s] ||= []

      return if repository.subscribers[to_s].include?(handler.to_s)

      repository.subscribers[to_s] << handler.to_s
    end
  end

  private

  def assign_record(record)
    @record = record
  end
end
