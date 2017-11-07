module Helpers
  def json_body
    JSON.parse(response.body)
  end
end

RSpec.configure do |c|
  c.include Helpers
end
