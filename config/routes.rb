Rails.application.routes.draw do
  scope :api do
    get '/products.get', to: 'products#index'
    post '/products.get', to: 'products#index'
  end

  root to: 'products#index'
end
