OmiseGO.configure do |config|
  config.access_key = ENV['ACCESS_KEY']
  config.secret_key = ENV['SECRET_KEY']
  config.base_url   = ENV['KUBERA_URL']
end
