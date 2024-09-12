Rails.application.routes.draw do
  # Rota para verificar a saúde do aplicativo
  get "up" => "rails/health#show", as: :rails_health_check

  # Rota de login
  post 'login', to: 'sessions#create'

  # Rotas para o administrador
  post 'admins/add_user', to: 'admins#add_user'
  delete 'admins/remove_user/:id', to: 'admins#remove_user', as: 'remove_user'
  get 'admins/list_users', to: 'admins#list_users'

  # Rotas para produtos
  post 'products/add', to: 'products#create', as: 'add_product'
  patch 'products/update/:id', to: 'products#update', as: 'update_product'
  delete 'products/remove/:id', to: 'products#destroy', as: 'remove_product'
  get 'products/list', to: 'products#index', as: 'list_products'
  get 'products/check_stock/:id', to: 'products#check_stock', as: 'check_product_stock'

  # Rotas para o carrinho
  post 'cart/add/:id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get 'cart', to: 'cart#show', as: 'show_cart'
  patch 'cart/update_quantity/:id', to: 'cart#update_quantity', as: 'update_cart_quantity'
  delete 'cart/remove_product/:product_id', to: 'cart#remove_product', as: 'cart_remove_product'
  delete 'cart/clear', to: 'cart#clear_cart', as: 'clear_cart'

  # Rotas para pagamentos
  post 'payment/create', to: 'payments#create', as: 'create_payment'
  post 'payment/add_balance', to: 'payments#add_balance', as: 'add_balance'
  post 'payment/get_balance', to: 'payments#get_balance', as: 'get_balance'
  post 'payment/validate', to: 'payments#validate', as: 'validate_payment'

  # Rotas Purchase
  get 'purchases', to: 'purchases#index'
  get 'purchases/show', to: 'purchases#show'
  post 'cart/final/add', to: 'purchases#add_to_final_cart', as: 'add_to_final_cart'
  get 'purchases/show_cart', to: 'purchases#show_cart', as: 'show_final_cart'
  delete 'purchases/remove_product/:product_id', to: 'purchases#remove_product', as: 'remove_final_product'
  delete 'purchases/clear_cart', to: 'purchases#clear_cart', as: 'clear_final_cart'
  get 'purchases/generate', to: 'purchases#generate_qrcode'
  post 'purchases/validate', to: 'purchases#validate_qrcode'
end