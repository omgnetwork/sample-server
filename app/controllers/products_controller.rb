class ProductsController < ActionController::API
  def index
    products = Product.all.map do |product|
      ProductSerializer.new(product)
    end

    render json: ResponseSerializer.new('1', true, products)
  end
end
