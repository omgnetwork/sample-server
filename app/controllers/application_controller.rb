class ApplicationController < ActionController::API
  include ErrorHandler
  include Authentication

  API_VERSION = '1'.freeze

  def serialize(data, success = true)
    render json: ResponseSerializer.new(API_VERSION, success, data)
  end
end
