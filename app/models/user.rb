class User < ApplicationRecord
  has_secure_password

  has_many :game_users
  has_many :games, through: :game_users

  validates_presence_of :email, :name
  validates_uniqueness_of :email
  validates :password, presence: true, on: :creates
  validates :password, presence: true, on: :update, allow_blank: true
  validates_confirmation_of :password

  enum status: %w(inactivated activated)

  def generate_api
    update!(api_key: SecureRandom.hex(32))
  end

  def send_activation
    UserActivationMailer.activation_email(self).deliver_now
  end

  def find_game(id)
    games.find(id)
  end
end
