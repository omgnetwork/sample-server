class ResponseSerializer
  def initialize(version, success, data)
    @version = version
    @success = success
    @data = data
  end

  def as_json(*)
    {
      version: @version,
      success: @success,
      data: @data
    }
  end
end
