module ErrorHandler
  ERRORS = {
    invalid_auth_scheme: {
      code: 'client:invalid_auth_scheme',
      description: 'The provided authentication scheme is not supported'
    },
    invalid_access_secret_key: {
      code: 'client:invalid_access_secret_key',
      description: 'Invalid access and/or secret key'
    },
    invalid_api_key: {
      code: 'client:invalid_api_key',
      description: "The provided API key can't be found or is invalid"
    },
    invalid_auth_token: {
      code: 'user:invalid_authentication_token',
      description: 'There is no user corresponding to the provided auth token'
    },
    invalid_parameter: {
      code: 'client:invalid_parameter',
      description: 'Invalid parameter provided'
    },
    invalid_credentials: {
      code: 'client:invalid_credentials',
      description: 'Incorrect username/password combination.'
    },
    invalid_version: {
      code: 'client:invalid_version',
      description: 'Invalid API version'
    },
    endpoint_not_found: {
      code: 'client:endpoint_not_found',
      description: 'Endpoint not found'
    },
    internal_server_error: {
      code: 'server:internal_server_error',
      description: 'Something went wrong on the server'
    }
  }.freeze

  def handle_error(code)
    error = ErrorSerializer.new(ERRORS[code][:code], ERRORS[code][:description])
    serialize(error, false)
  end

  def handle_error_with_messages(code, messages)
    error = ErrorSerializer.new(ERRORS[code][:code],
                                ERRORS[code][:description],
                                messages)
    serialize(error, false)
  end
end
