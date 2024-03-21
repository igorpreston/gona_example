module Scheduleable
  extend ActiveSupport::Concern

  WEEK_DAY_NAMES = {
    'MON' => 'Monday',
    'TUE' => 'Tuesday',
    'WED' => 'Wednesday',
    'THU' => 'Thursday',
    'FRI' => 'Friday',
    'SAT' => 'Saturday',
    'SUN' => 'Sunday'
  }.freeze

  included do
    include StoreModel::NestedAttributes

    attribute :schedule, Period.to_array_type

    # this line is causing rails db:migrate to fail
    accepts_nested_attributes_for [:schedule, { schedule: :_destroy, allow_destroy: true }]
  end

  def open?
    current_day = Time.now.strftime('%A').downcase
    current_time = Time.now.strftime('%H:%M')

    schedule_for_today = schedule.select { |period| period['day_of_week'] == current_day }

    return false unless schedule_for_today.present?

    schedule_for_today.any? do |period|
      start_time = Time.parse(period['start_local_time'])
      end_time = Time.parse(period['end_local_time'])

      current_time.between?(start_time.strftime('%H:%M'), end_time.strftime('%H:%M'))
    end
  end

  def closed?
    !open?
  end

  def today
    day_of_week = Date.today.strftime('%A').downcase

    schedule.select { |entry| entry['day_of_week'] == day_of_week }
  end
end
