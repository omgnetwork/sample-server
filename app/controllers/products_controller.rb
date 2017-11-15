class ProductsController < ApplicationController
  before_action :authenticate_client

  def index
    products = Product.all.map do |product|
      ProductSerializer.new(product)
    end

    serialize(ListSerializer.new(products))
  end
end
