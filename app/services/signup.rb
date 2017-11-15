class Signup
  def initialize(params, api_key)
    @params = params
    @api_key = api_key
  end

  def call
    return false unless user.save
    return false if omisego_user.error?

    user
  end

  def error
    @error ||= omisego_user.error? ? omisego_user.to_s : nil
  end

  private

  def omisego_user
    @omisego_user ||= OmiseGO::User.create(omisego_params)
  end

  def omisego_params
    {
      provider_user_id: user.provider_user_id,
      username: user.email,
      metadata: {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name
      }
    }
  end

  def user
    @user ||= User.find_by(email: @params[:email]) || User.new(@params)
  end
end
