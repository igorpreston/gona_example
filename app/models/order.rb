# == Schema Information
#
# Table name: orders
#
#  id                       :bigint           not null, primary key
#  added_items_count        :integer          default(0), not null
#  cancelled_at             :datetime
#  completed_at             :datetime
#  discarded_at             :datetime
#  feedbacks_count          :integer          default(0), not null
#  in_progress_at           :datetime
#  items_count              :integer          default(0), not null
#  number                   :string
#  number_of_people         :integer          default(1)
#  payment_split_type       :string
#  payments_count           :integer          default(0), not null
#  platform                 :string           not null
#  preference               :string           not null
#  preparation_time_seconds :integer          default(0), not null
#  ready_at                 :datetime
#  receipt_number           :string
#  scheduled_for            :datetime
#  status                   :string           not null
#  submitted_at             :datetime
#  tracking_token           :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  cart_id                  :bigint
#  clover_id                :string
#  location_id              :bigint           not null
#  organization_id          :bigint           not null
#  square_id                :string
#  table_id                 :bigint
#
# Indexes
#
#  index_orders_on_cart_id          (cart_id)
#  index_orders_on_clover_id        (clover_id)
#  index_orders_on_discarded_at     (discarded_at)
#  index_orders_on_location_id      (location_id)
#  index_orders_on_organization_id  (organization_id)
#  index_orders_on_table_id         (table_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_id => carts.id)
#
class Order < ApplicationRecord
  include Pricing
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: Order::Transition,
    initial_state: :draft,
    transition_name: :transitions
  ]

  has_prefix_id :ord, minimum_length: 18

  acts_as_tenant :organization

  belongs_to :location
  belongs_to :user, optional: true
  belongs_to :table, optional: true
  belongs_to :cart, optional: true, class_name: Storefront::Cart.name

  has_one :note, as: :notable

  has_many :feedbacks
  has_many :payments
  has_many :logs, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items
  has_many :transitions, autosave: false
  has_many :order_users, dependent: :destroy

  before_create :number!, if: -> { number.blank? }
  before_create :tracking_token!, if: -> { tracking_token.blank? }
  before_create :receipt_number!, if: -> { receipt_number.blank? }

  after_commit :publish_created!, on: :create
  after_commit :publish_submitted!, on: :update, if: -> { saved_change_to_status? && submitted? }
  after_commit :publish_in_progress!, on: :update, if: -> { saved_change_to_status? && in_progress? }
  after_commit :publish_ready!, on: :update, if: -> { saved_change_to_status? && ready? }
  after_commit :publish_completed!, on: :update, if: -> { saved_change_to_status? && completed? }
  after_commit :publish_cancelled!, on: :update, if: -> { saved_change_to_status? && cancelled? }

  counter_culture :cart, column_name: proc { |model| model.draft? ? 'draft_orders_count' : nil }

  enum status: {
    draft: 'draft',
    ongoing: 'ongoing',
    submitted: 'submitted',
    in_progress: 'in_progress',
    ready: 'ready',
    completed: 'completed',
    cancelled: 'cancelled'
  }, _default: 'draft'

  enum preference: {
    take_out: 'take_out',
    dine_in: 'dine_in'
  }, _default: 'take_out'

  enum platform: {
    gona: 'gona'
  }, _default: 'gona'

  enum payment_split_type: {
    equal: 'equal',
    individual: 'individual',
    by_item: 'by_item',
    custom: 'custom'
  }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :preference, presence: true, inclusion: { in: preferences.keys }
  validates :platform, presence: true, inclusion: { in: platforms.keys }
  validates :payment_split_type, inclusion: { in: payment_split_types.keys }, allow_nil: true
  validates :number_of_people, presence: true, numericality: {
    only_integer: true, greater_than: 0
  }, if: -> { dine_in? }

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  def state_machine
    @state_machine ||= Order::StateMachine.new(
      self,
      transition_class: Order::Transition,
      association_name: :transitions
    )
  end

  def ready_by_seconds
    (in_progress_at.to_i || 0) + (preparation_time_seconds || location.expected_preparation_time_seconds)
  end

  def ready_by
    Time.zone.at(ready_by_seconds) if ready_by_seconds.positive?
  end

  def progress_percentage
    return 100 if completed? || cancelled?

    steps = %i[submitted_at? in_progress_at? ready_at? completed_at?]
    complete = steps.count { |step| send(step) }
    complete.to_f / steps.count * 100
  end

  def total_quantity
    order_items.where(status: :added).sum(&:quantity)
  end

  def finished?
    ready? || completed? || cancelled?
  end

  def number!
    self.number = loop do
      code = 6.times.map { [*'1'..'9', *'a'..'n', *'p'..'w'].sample }.join.upcase
      break code unless self.class.exists?(number: code)
    end
  end

  def tracking_token!
    self.tracking_token = loop do
      code = SecureRandom.hex(20)
      break code unless self.class.exists?(tracking_token: code)
    end
  end

  def receipt_number!
    self.receipt_number = loop do
      number = "RCT-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
      break number unless self.class.exists?(receipt_number: number)
    end
  end

  private

  def publish_submitted!
    publish_event Order::Submitted, id:
  end

  def publish_created!
    publish_event Order::Created, id:
  end

  def publish_in_progress!
    publish_event Order::InProgress, id:
  end

  def publish_ready!
    publish_event Order::Ready, id:
  end

  def publish_completed!
    publish_event Order::Completed, id:
  end

  def publish_cancelled!
    publish_event Order::Cancelled, id:
  end

  def scheduled_for_date(datetime)
    days = %i[sunday monday tuesday wednesday thursday friday saturday]
    day_index = datetime.wday
    days[day_index]
  end

  def round_to_nearest_15_minutes(time)
    minute = time.min
    rounded_minute = (minute / 15.0).round * 15
    time.change(min: rounded_minute)
  end
end
