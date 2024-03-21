class Clover::KillRefreshTokenWorker
  include Sidekiq::Worker

  sidekiq_options queue: :clover, retry: false

  def perform(integration_id)
    scheduled_set = Sidekiq::ScheduledSet.new

    scheduled_set.map do |job|
      job.delete if job.klass == 'Clover::RefreshTokenWorker' && job.args == [integration_id]
    end
  end
end
