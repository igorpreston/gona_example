class Period
  include StoreModel::Model

  DAYS = %i[monday tuesday wednesday thursday friday saturday sunday].freeze

  attribute :day_of_week, :string
  attribute :start_local_time, :string
  attribute :end_local_time, :string

  validates :day_of_week, presence: true, inclusion: { in: DAYS }
  validates :start_local_time, presence: true, format: { with: /\A\d{2}:\d{2}\z/ }, if: -> { end_local_time.present? }
  validates :end_local_time, presence: true, format: { with: /\A\d{2}:\d{2}\z/ }, if: -> { start_local_time.present? }

  def start_local_time_am_pm
    Time.parse(start_local_time).strftime('%l:%M %p')
  end

  def end_local_time_am_pm
    Time.parse(end_local_time).strftime('%l:%M %p')
  end
end
