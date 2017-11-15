class AccessTokenSerializer
  def initialize(access_token, token)
    @access_token = access_token
    @token = token
  end

  def as_json(*)
    {
      object: 'authentication_token',
      user_id: @access_token.user.id.to_s,
      authentication_token: @token,
      omisego_authentication_token: @access_token.omisego_authentication_token
    }
  end
end
