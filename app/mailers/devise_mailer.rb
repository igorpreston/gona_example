# This is a custom mailer for Devise mailers.
# It is used to send emails to users and override the default Devise mailer.
#
# For the notifications, we use the Noticed gem.
class DeviseMailer < Devise::Mailer
  helper :application

  include Devise::Controllers::UrlHelpers

  default template_path: 'devise/mailer'
  default from: ->(*) { Class.instance.email_address }

  def confirmation_instructions(record, token, opts = {})
    record.class.name.constantize::ConfirmationInstructionsNotification.with(record:, token:, opts:).deliver(record)
  end

  def reset_password_instructions(record, token, opts = {})
    record.class.name.constantize::ResetPasswordInstructionsNotification.with(record:, token:, opts:).deliver(record)
  end

  def unlock_instructions(record, token, opts = {})
    # not implemented
  end

  def invitation_instructions(record, token, opts = {})
    record.class.name.constantize::InvitationInstructionsNotification.with(record:, token:, opts:).deliver(record)
  end
end
