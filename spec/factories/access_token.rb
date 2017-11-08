FactoryBot.define do
  factory :access_token do
    token_digest nil
    accessed_at '2016-06-09 18:14:41'
    user
    api_key
  end
end
