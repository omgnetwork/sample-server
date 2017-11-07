class Product < ApplicationRecord
  monetize :price_satangs

  validates :name, presence: true
  validates :price, presence: true
end
