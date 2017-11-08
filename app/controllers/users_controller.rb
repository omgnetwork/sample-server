class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[me update destroy]

  def me
    serialize(UserSerializer.new(current_user))
  end

  def create
    user = User.new(user_params)

    if user.save
      access_token, token = TokenGenerator.new(user, api_key).generate
      serialize(AccessTokenSerializer.new(access_token, token))
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
