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
class Integration::Clover < Integration
  BASE_URL_SANDBOX = 'https://apisandbox.dev.clover.com'.freeze
  BASE_URL_PRODUCTION_NA = 'https://api.clover.com'.freeze
  AUTH_URL_SANDBOX = 'https://apisandbox.dev.clover.com/oauth/v2/token'.freeze
  AUTH_URL_PRODUCTION_NA = 'https://api.clover.com/oauth/v2/token'.freeze
  AUTH_REFRESH_URL_SANDBOX = 'https://apisandbox.dev.clover.com/oauth/v2/refresh'.freeze
  AUTH_REFRESH_URL_PRODUCTION_NA = 'https://api.clover.com/oauth/v2/refresh'.freeze

  PAY_TYPES = {
    'SPLIT_GUEST' => Order.payment_split_types[:equally],
    'SPLIT_ITEM' => Order.payment_split_types[:by_item],
    'SPLIT_CUSTOM' => Order.payment_split_types[:custom],
    'FULL' => Order.payment_split_types[:individual]
  }

  after_create :schedule_next_refresh!, if: -> { access_token_expiration.present? }

  before_destroy :kill_refresh_token_worker!, if: -> { access_token_expiration.present? }

  store_accessor :configs, :access_token
  store_accessor :configs, :refresh_token
  store_accessor :configs, :access_token_expiration
  store_accessor :configs, :refresh_token_expiration

  # Authentication with Clover
  def self.connect_url
    base_url = Rails.env.production? ? 'https://www.clover.com' : 'https://sandbox.dev.clover.com'
    "#{base_url}/oauth/v2/authorize?client_id=#{ENV['CLOVER_APPLICATION_ID']}&response_type=code"
  end

  def items(filter: nil, expand: nil, limit: nil, offset: nil)
    endpoint = 'items'
    endpoint += "?filter=#{filter}" if filter.present?
    endpoint += "&expand=#{expand}" if expand.present?
    endpoint += "&limit=#{limit}" if limit.present?
    endpoint += "&offset=#{offset}" if offset.present?

    get_data_from_clover(endpoint)
  end

  def categories(filter: nil, expand: nil, limit: nil, offset: nil)
    endpoint = 'categories'
    endpoint += "?filter=#{filter}" if filter.present?
    endpoint += "&expand=#{expand}" if expand.present?
    endpoint += "&limit=#{limit}" if limit.present?
    endpoint += "&offset=#{offset}" if offset.present?

    get_data_from_clover(endpoint)
  end

  def category_items(category_id, filter: nil, expand: nil, limit: nil, offset: nil)
    endpoint = "categories/#{category_id}/items"
    endpoint += "?filter=#{filter}" if filter.present?
    endpoint += "&expand=#{expand}" if expand.present?
    endpoint += "&limit=#{limit}" if limit.present?
    endpoint += "&offset=#{offset}" if offset.present?

    get_data_from_clover(endpoint)
  end

  def properties
    endpoint = 'properties'

    get_data_from_clover(endpoint)
  end

  def orders
    get_data_from_clover('orders')
  end

  private

  def publish_created!
    publish_event Integration::Clover::Created, id:
  end

  def schedule_next_refresh!
    ::Clover::RefreshTokenWorker.perform_at(
      DateTime.parse(access_token_expiration) - 1.hour,
      id
    )
  end

  def kill_refresh_token_worker!
    ::Clover::KillRefreshTokenWorker.perform_async(id)
  end

  def get_data_from_clover(endpoint)
    url = "#{base_url}/v3/merchants/#{organization.clover_id}/#{endpoint}"

    headers = {
      'Accept' => 'application/json',
      'Authorization' => "Bearer #{access_token}"
    }

    HTTParty.get(url, headers:)
  end

  def base_url
    Rails.env.production? ? BASE_URL_PRODUCTION_NA : BASE_URL_SANDBOX
  end
end
