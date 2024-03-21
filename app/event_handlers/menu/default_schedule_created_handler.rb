class Menu::DefaultScheduleCreatedHandler < EventHandler
  on Menu::Created

  def perform
    ActiveRecord::Base.transaction do
      menu.update!(schedule:) if menu.schedule.blank?
    end
  end

  private

  def menu
    @menu ||= Menu.lock.find(event.id)
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
