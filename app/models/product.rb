class Product < ApplicationRecord
  monetize :price_cents

  validates :name, presence: true
  validates :price, presence: true
end
