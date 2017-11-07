# This file should contain all the record creation needed to seed the database
# ith its default values. The data can then be loaded with the rails db:seed
# command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create!(
  name: 'OmiseGO T-Shirt',
  description: 'An amazing t-shirt!',
  price: Money.new(1990, 'THB')
)

Product.create!(
  name: 'OmiseGO Hoodie',
  description: 'An amazing hoodie!',
  price: Money.new(3990, 'THB')
)

Product.create!(
  name: 'OmiseGO Hat',
  description: 'An amazing hat!',
  price: Money.new(990, 'THB')
)
