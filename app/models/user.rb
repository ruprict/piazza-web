# frozen_string_literal: true

# user class
class User < ApplicationRecord
  include Authentication
  validates :name, presence: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  normalizes :name, with: ->(name) { name.strip }
  normalizes :email, with: ->(email) { email.strip.downcase }
end
