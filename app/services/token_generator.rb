class TokenGenerator
  def initialize(user, api_key)
    @user = user
    @api_key = api_key
  end

  def generate
    AccessToken.find_by(user: @user, api_key: @api_key).try(:destroy)

    access_token = AccessToken.create(user: @user, api_key: @api_key)
    token = access_token.generate_token

    [access_token, token]
  end
end
