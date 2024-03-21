class Organization::CreateOnboarding < Operation
  class Params < Operation::Params
    attribute :organization_id, Types::Coercible::String
  end

  class Response < Operation::Response
    attribute :onboarding_id, Types::Coercible::String
  end

  def perform
    onboarding = create_onboarding_with_tasks!

    { onboarding_id: onboarding.id }
  end

  private

  def create_onboarding_with_tasks!
    organization.create_onboarding.tap do |onboarding|
      assign_onboarding_tasks(onboarding)

      onboarding.save!
    end
  end

  # [NOTES]
  # We can assign tasks based on the organization's business_type
  #
  # 1. finish setting up the account - stripe (how do we check if this is completed?)
  # 2. add a POS integration
  # 3. add location
  #
  # 4. add a product
  # 5. add a category
  # 6. add a menu
  def assign_onboarding_tasks(onboarding)
    onboarding.tasks << [
      onboarding.tasks.find_or_initialize_by(template: :complete_stripe_onboarding, category: :organization_settings),
      onboarding.tasks.find_or_initialize_by(template: :create_location, category: :organization_settings),
      onboarding.tasks.find_or_initialize_by(template: :create_integration, category: :organization_settings),
      onboarding.tasks.find_or_initialize_by(template: :create_product, category: :organization_inventory),
      onboarding.tasks.find_or_initialize_by(template: :create_category, category: :organization_inventory),
      onboarding.tasks.find_or_initialize_by(template: :create_menu, category: :organization_inventory)
    ]
  end

  def organization
    @organization ||= Organization.find(params.organization_id)
  end
end
