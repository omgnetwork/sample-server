FactoryBot.define do
  factory :product do
    name 'OmiseGO T-Shirt'
    description 'Something cool'
    price Money.new(1900, 'THB')
  end
end
