class Product < ApplicationRecord
  monetize :price_satangs, as: :price

  validates :name, presence: true
  validates :price, presence: true
end
