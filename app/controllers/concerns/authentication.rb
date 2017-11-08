module Authentication
  extend ActiveSupport::Concern

  AUTH_SCHEME = 'OMGShop'.freeze

  included do
    before_action :validate_auth_scheme
    before_action :authenticate_client
  end

  private

  def validate_auth_scheme
    handle_error(:invalid_auth_scheme) unless AUTH_SCHEME == authenticator.scheme
  end

  def authenticate_client
    handle_error(:invalid_api_key) unless authenticator.valid_client?
  end

  def authenticate_user
    handle_error(:invalid_auth_token) unless authenticator.valid_user?
  end

  def authorization_request
    @authorization_request ||= request.authorization.to_s
  end

  def authenticator
    @authenticator ||= Authenticator.new(authorization_request)
  end

  def api_key
    @api_key ||= authenticator.api_key
  end

  def access_token
    @access_token ||= authenticator.access_token
  end

  def current_user
    @current_user ||= access_token.try(:user)
  end
end
