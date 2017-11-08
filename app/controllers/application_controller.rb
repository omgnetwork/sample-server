class ApplicationController < ActionController::API
  include ErrorHandler
  include Authentication

  def serialize(data, success = true)
    render json: ResponseSerializer.new('1', success, data)
  end
end
