class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :user

  before_save :set_price

  store :error
  monetize :price_satangs
  enum status: { created: 0, sent: 1, confirmed: 2, rejected: 3 }

  validates :price_satangs, presence: true
  validates :product, presence: true
  validates :user, presence: true
  validates :idempotency_token, presence: true

  def confirm!
    confirmed!
  end

  def error!(error)
    rejected!
    update_column :error, error
  end

  private

  def set_price
    self.price = product.price
  end
end
