# == Schema Information
#
# Table name: integrations
#
#  id              :bigint           not null, primary key
#  configs         :jsonb            not null
#  type            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  app_id          :bigint
#  organization_id :bigint           not null
#
# Indexes
#
#  index_integrations_on_app_id           (app_id)
#  index_integrations_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (app_id => apps.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class Integration::Square < Integration
  SQUARE_STATE_TO_ORDER_STATE = {
    'PROPOSED' => Order.statuses[:submitted],
    'RESERVED' => Order.statuses[:in_progress],
    'PREPARED' => Order.statuses[:ready],
    'COMPLETED' => Order.statuses[:completed],
    'CANCELED' => Order.statuses[:cancelled],
    'FAILED' => Order.statuses[:cancelled]
  }.freeze

  after_create :publish_created!, if: -> { access_token.present? }
  after_create :schedule_next_refresh!, if: -> { refresh_token.present? }

  before_destroy :disconnect_square!, if: -> { access_token.present? }
  before_destroy :kill_refresh_token_worker!, if: -> { refresh_token.present? }

  after_destroy :publish_destroyed!

  store_accessor :configs, :access_token
  store_accessor :configs, :refresh_token
  store_accessor :configs, :expires_at

  def self.connect_url
    "#{ENV.fetch('SQUARE_CONNECT_HOST',
                 nil)}/oauth2/authorize?client_id=#{ENV.fetch('SQUARE_APPLICATION_ID',
                                                              nil)}&scope=#{ENV.fetch('SQUARE_APPLICATION_SCOPE',
                                                                                      nil)}".freeze
  end

  private

  def disconnect_square!
    oauth_api.revoke_token(
      body: {
        access_token:,
        client_id: ENV.fetch('SQUARE_APPLICATION_ID', nil)
      },
      authorization: "Client #{ENV.fetch('SQUARE_APPLICATION_SECRET', nil)}"
    )

    organization.update(square_id: nil)
  end

  def oauth_api
    @client ||= ::Square::Client.new(
      environment: ENV.fetch('SQUARE_ENVIRONMENT', nil),
      access_token: ENV.fetch('SQUARE_APPLICATION_SECRET', nil),
      user_agent_detail: 'GONA'
    )

    @client.o_auth
  end

  def publish_created!
    publish_event Integration::Square::Created, id:
  end

  def publish_destroyed!
    publish_event Integration::Square::Destroyed, id:, organization_id:
  end

  def schedule_next_refresh!
    ::Square::RefreshTokenWorker.perform_in(7.days, id)
  end

  def kill_refresh_token_worker!
    ::Square::KillRefreshTokenWorker.perform_async(id)
  end
end
