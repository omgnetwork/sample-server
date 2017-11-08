class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      object: 'user',
      id: @user.id.to_s,
      email: @user.email,
      first_name: @user.first_name,
      last_name: @user.last_name
    }
  end
end
