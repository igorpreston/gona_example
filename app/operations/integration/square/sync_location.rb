class Integration::Square::SyncLocation < Operation
  include SquareClient

  class Params < Operation::Params
    attribute :square_location_object, Types::Coercible::Hash
  end

  class Response < Operation::Response
    attribute :merchant_id, Types::Coercible::String
  end

  def perform
    square_object = params.square_location_object

    return unless square_object.present?

    organization = find_organization(square_object[:merchant_id])
    integration = find_square_integration(organization)

    return unless organization && integration

    process_square_location(organization, square_object)

    { merchant_id: organization.square_id }
  end

  private

  def find_organization(merchant_id)
    return unless merchant_id.present?

    Organization.find_by(square_id: merchant_id)
  end

  def find_square_integration(organization)
    organization&.integrations&.find_by(type: Integration::Square.name)
  end

  def process_square_location(organization, square_location)
    square_location_status = square_location[:status]&.downcase

    case square_location_status
    when 'active'
      create_or_update_location(organization, square_location)
    when 'inactive'
      delete_location(organization, square_location)
    end
  end

  def create_or_update_location(organization, square_location)
    location = organization.locations.with_deleted.find_or_initialize_by(square_id: square_location[:id])
    location.attributes = map_location_attributes(square_location)
    location.save!
  end

  def delete_location(organization, square_location)
    organization.locations.find_by(square_id: square_location[:id])&.destroy
  end

  def map_location_attributes(square_location)
    {
      name: square_location[:name],
      location_type: map_location_type(square_location[:type]&.downcase),
      currency: square_location[:currency]&.upcase,
      timezone: square_location[:timezone],
      address_attributes: map_address(square_location[:address]),
      schedule_attributes: map_schedule(square_location[:business_hours]),
      deleted_at: nil
    }
  end

  def map_location_type(square_location_type)
    square_location_type == 'physical' ? Location.location_types[:physical] : Location.location_types[:mobile]
  end

  def map_address(square_address)
    {
      line_one: square_address&.dig(:address_line_1),
      line_two: square_address&.dig(:address_line_2),
      zip: square_address&.dig(:postal_code),
      state: square_address&.dig(:administrative_district_level_1),
      city: square_address&.dig(:locality),
      country: square_address&.dig(:country)&.upcase
    }
  end

  def map_schedule(square_schedule)
    return [] if square_schedule.blank?

    square_schedule[:periods].map do |period|
      {
        day_of_week: Scheduleable::WEEK_DAY_NAMES[period[:day_of_week]]&.downcase,
        start_local_time: period[:start_local_time],
        end_local_time: period[:end_local_time]
      }
    end
  end
end
