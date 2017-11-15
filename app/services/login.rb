class Login
  def initialize(user, api_key)
    @user = user
    @api_key = api_key
  end

  def call
    return false if omisego_token.error?

    token_generator.generate
  end

  def access_token
    @access_token ||= token_generator.access_token
  end

  private

  def token_generator
    @token_generator ||= TokenGenerator.new(@user, @api_key, omisego_token)
  end

  def omisego_token
    @omisego_token ||= OmiseGO::User.login(provider_user_id: @user.provider_user_id)
  end

  def error
    @error ||= omisego_token.error? ? omisego_token.to_s : nil
  end
end
