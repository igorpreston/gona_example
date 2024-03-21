class OrganizationsController < ApplicationController
  before_action :organization, only: %i[show account public health update]

  def new
    return check_existing_organization if current_merchant.organization_id?

    organization = Organization.new
    organization.build_address

    render layout: 'organization', locals: { organization: }
  end

  def create
    return check_existing_organization if current_merchant.organization_id?

    organization = Organization.new(organization_params).tap do |org|
      org.owner = current_merchant
    end

    organization.merchants << current_merchant.tap { |merchant| merchant.role = :owner }

    if organization.save!
      redirect_to root_path, notice: 'Organization was successfully created.'
    else
      redirect_to new_organization_path, notice: organization.errors.full_messages.to_sentence, turbolinks: false
    end
  end

  def edit
    render locals: { organization: }
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :email)
  end

  def organization
    @organization ||= current_tenant
  end

  def check_existing_organization
    redirect_to root_path
  end
end
