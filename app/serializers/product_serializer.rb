class ProductSerializer
  def initialize(product)
    @product = product
  end

  def as_json(*)
    {
      object: 'product',
      id: @product.id,
      name: @product.name,
      description: @product.description,
      image_url: @product.image_url || '',
      price: @product.price_satangs,
      currency: 'THB'
    }
  end
end
