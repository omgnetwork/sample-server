class TokenGenerator
  def initialize(user, api_key, omisego_token)
    @user = user
    @api_key = api_key
    @omisego_token = omisego_token
  end

  def generate
    AccessToken.find_by(user: @user, api_key: @api_key).try(:destroy)
    access_token.generate_token
  end

  def access_token
    @access_token ||= AccessToken.create(
      user: @user,
      api_key: @api_key,
      omisego_authentication_token: @omisego_token.authentication_token
    )
  end
end
