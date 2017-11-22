class User < ApplicationRecord
  has_secure_password
  has_many :access_tokens

  before_validation :downcase_email
  before_validation :set_uuid, only: :create

  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :uuid, presence: true
  validates :password, presence: true, length: { minimum: 8 }, if: :new_record?

  def provider_user_id
    uuid
  end

  private

  def downcase_email
    email.downcase! if email
  end

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
