class ListSerializer
  def initialize(data)
    @data = data
  end

  def as_json(*)
    {
      object: 'list',
      data: @data
    }
  end
end
