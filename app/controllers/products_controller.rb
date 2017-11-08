class ProductsController < ApplicationController
  before_action :authenticate_client

  def index
    serialize(Product.all.map do |product|
      ProductSerializer.new(product)
    end)
  end
end
