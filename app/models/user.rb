# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  dob                    :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           default("")
#  last_name              :string           default("")
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_customer_id     :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_prefix_id :usr, minimum_length: 18

  has_person_name

  has_one :cart, class_name: Storefront::Cart.name

  has_many :order_users
  has_many :orders, through: :order_users
  has_many :payments
  has_many :notes
  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  has_one_attached :avatar, dependent: :destroy

  phony_normalize :phone, default_country_code: Rails.application.config.country

  validates :first_name, presence: true, unless: -> { invitation_sent_at? }
  validates :last_name, presence: true, unless: -> { invitation_sent_at? }
  validates :stripe_customer_id, uniqueness: true, allow_blank: true
end
