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
  price: Money.new(98_500, 'THB'),
  image_url: 'https://image.ibb.co/cyfcfm/tshirt_sample_3x.png'
)

Product.create!(
  name: 'OmiseGO Hoodie',
  description: 'An amazing hoodie!',
  price: Money.new(15_500, 'THB'),
  image_url: 'https://image.ibb.co/cyfcfm/tshirt_sample_3x.png'
)

Product.create!(
  name: 'OmiseGO Hat',
  description: 'An amazing hat!',
  price: Money.new(45_000, 'THB'),
  image_url: 'https://image.ibb.co/cyfcfm/tshirt_sample_3x.png'
)
