class ErrorSerializer
  def initialize(code, description, messages = nil)
    @code = code
    @description = description
    @messages = messages
  end

  def as_json(*)
    {
      object: 'error',
      code: @code,
      description: @description,
      messages: @messages
    }
  end
end
