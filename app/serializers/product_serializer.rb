class ProductSerializer
  def initialize(product)
    @product = product
  end

  def as_json(*)
    {
      object: 'product',
      id: @product.id.to_s,
      name: @product.name,
      description: @product.description,
      image_url: @product.image_url || '',
      price: @product.price_cents,
      currency: 'THB'
    }
  end
end
