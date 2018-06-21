OmiseGO.configure do |config|
  config.access_key = ENV['OMISEGO_ACCESS_KEY']
  config.secret_key = ENV['OMISEGO_SECRET_KEY']
  config.base_url   = ENV['OMISEGO_EWALLET_URL']
  config.logger     = Rails.logger
end
