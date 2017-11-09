Rails.application.routes.draw do
  scope :api do
    get '/products.get', to: 'products#index'
    post '/products.get', to: 'products#index'

    post '/product.buy', to: 'purchases#create'

    post '/login', to: 'access_tokens#create'
    post '/logout', to: 'access_tokens#destroy'

    post '/signup', to: 'users#create'
    post '/me.get', to: 'users#me'
    post '/me.update', to: 'users#update'
    post '/me.delete', to: 'users#destroy'
  end

  root to: 'status#index'
end
