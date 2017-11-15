class AccessTokensController < ApplicationController
  before_action :authenticate_user, only: :destroy

  def create
    user = User.find_by(email: login_params[:email])

    if user && user.authenticate(login_params[:password])
      login = Login.new(user, api_key)

      if (token = login.call)
        data = AccessTokenSerializer.new(login.access_token, token)
        serialize(data)
      else
        handle_error(:invalid_parameter)
      end
    else
      handle_error(:invalid_credentials)
    end
  end

  def destroy
    access_token.destroy
    serialize({})
  end

  private

  def login_params
    params.permit(:email, :password, :first_name, :last_name)
  end
end
