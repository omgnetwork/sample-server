ENV['ACCOUNT_ID'] = 'acc_01cfy9350215sgwxs11tqnqw9t' unless Rails.env.prod?
raise "OmiseGO eWallet master 'ACCOUNT_ID' ENV not set" unless ENV['ACCOUNT_ID']

OmiseGO.configure do |config|
  config.access_key = ENV['OMISEGO_ACCESS_KEY']
  config.secret_key = ENV['OMISEGO_SECRET_KEY']
  config.base_url   = ENV['OMISEGO_EWALLET_URL']
  config.logger     = Rails.logger
end
