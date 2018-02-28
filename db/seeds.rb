# This file should contain all the record creation needed to seed the database
# ith its default values. The data can then be loaded with the rails db:seed
# command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create!(
  name: 'Grey T-Shirt',
  description: 'An amazing grey t-shirt!',
  price: Money.new(98_500, 'THB'),
  image_url: 'https://image.ibb.co/kXoGtH/thsirt_grey.jpg'
)

Product.create!(
  name: 'Navy T-Shirt',
  description: 'An amazing navy t-shirt!',
  price: Money.new(15_500, 'THB'),
  image_url: 'https://image.ibb.co/dVjBSc/tshirt_navy.jpg'
)

Product.create!(
  name: 'Blue T-Shirt',
  description: 'An amazing blue t-shirt!',
  price: Money.new(45_000, 'THB'),
  image_url: 'https://image.ibb.co/cot5nc/tshirt_blue.jpg'
)
