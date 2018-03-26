class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email, :name, :password
  validates_confirmation_of :password
  enum status: %w(inactivated activated)

  def activate
    update(status: 1)
  end

  def generate_api
    update(api_key: SecureRandom.hex(32))
  end
end
