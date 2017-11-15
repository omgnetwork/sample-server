class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[me update destroy]

  def me
    serialize(UserSerializer.new(current_user))
  end

  def create
    signup = Signup.new(user_params, api_key)
    user = signup.call

    if user
      login = Login.new(user, api_key)

      if (token = login.call)
        data = AccessTokenSerializer.new(login.access_token, token)
        serialize(data)
      else
        handle_error_with_description(:invalid_parameter, token.error)
      end
    elsif signup.error
      handle_error_with_description(:invalid_parameter, signup.error)
    else
      handle_error(:invalid_parameter)
    end
  end

  def update
    if current_user.update(user_params)
      serialize(UserSerializer.new(current_user.reload))
    else
      handle_error(:invalid_parameter)
    end
  end

  def destroy
    current_user.destroy
    serialize({})
  end

  private

  def user_params
    params.permit(:email, :password, :first_name, :last_name)
  end
end
