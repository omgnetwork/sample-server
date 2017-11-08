# app/services/authenticator.rb
class Authenticator
  include ActiveSupport::SecurityUtils

  CREDENTIALS = %i[api_key_id api_key user_id access_token].freeze

  def initialize(authorization)
    @authorization = authorization.delete("\n").split(' ')
  end

  def scheme
    @scheme ||= @authorization.first
  end

  def valid_client?
    return false unless credentials[:api_key_id] && credentials[:api_key]
    return false unless api_key
    secure_compare_with_hashing(api_key.key, credentials[:api_key])
  end

  def valid_user?
    return false unless api_key && credentials[:user_id] && credentials[:access_token]
    return false unless access_token
    access_token.authenticate(credentials[:access_token])
  end

  def api_key
    @api_key ||= ApiKey.activated.find_by(id: credentials[:api_key_id])
  end

  def user
    @user ||= User.find_by(id: credentials[:user_id])
  end

  def access_token
    @access_token ||= AccessToken.find_by(user: user, api_key: api_key)
  end

  def credentials
    @credentials ||= CREDENTIALS.each_with_object({}).with_index do |(key, hash), index|
      hash[key] = decoded_credentials[index]
    end
  end

  private

  def decoded_credentials
    @decoded_credentials ||= Base64.decode64(@authorization.last).split(':')
  end

  def secure_compare_with_hashing(a, b)
    secure_compare(Digest::SHA1.hexdigest(a), Digest::SHA1.hexdigest(b))
  end
end
