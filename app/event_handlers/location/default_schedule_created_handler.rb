class Location::DefaultScheduleCreatedHandler < EventHandler
  on Location::Created

  def perform
    ActiveRecord::Base.transaction do
      location.update!(schedule:) if location.schedule.blank?
    end
  end

  private

  def location
    @location ||= Location.lock.find(event.id)
  end

  def schedule
    [
      { day_of_week: 'monday', start_local_time: '00:00', end_local_time: '23:59' },
      { day_of_week: 'tuesday', start_local_time: '00:00', end_local_time: '23:59' },
      { day_of_week: 'wednesday', start_local_time: '00:00', end_local_time: '23:59' },
      { day_of_week: 'thursday', start_local_time: '00:00', end_local_time: '23:59' },
      { day_of_week: 'friday', start_local_time: '00:00', end_local_time: '23:59' },
      { day_of_week: 'saturday', start_local_time: '00:00', end_local_time: '23:59' },
      { day_of_week: 'sunday', start_local_time: '00:00', end_local_time: '23:59' }
    ]
  end
end
