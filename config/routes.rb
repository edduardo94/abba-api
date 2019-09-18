# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1') do
    ####USERS####
    post 'user/myself', to: 'users#myself'
    post 'user/profile', to: 'users#show'
    post 'signup', to: 'users#create'
    post 'auth/login', to: 'users#authenticate'
    post 'users/forgot_password', to: 'users#forgot_password'
    post 'users/address/add', to: 'users#create_address'
    post 'users/address/delete', to: 'users#destroy_address'
    put  'users/:id', to: 'users#update'
    put  'users/update/password', to: 'users#update_password'
    put  'users/address/update', to: 'users#update_address'

    ####ORDERS####
    post 'orders/calc_frete', to: 'orders#calc_frete'
    post 'orders', to: 'orders#create'
    post 'orders/checkout/process_payment', to: 'checkouts#process_payment'
    get  'orders', to: 'orders#show_all'
    get  'orders/:id', to: 'orders#show'

    ####CATEGORIES####
    get  'categories', to: 'categories#show'
    get  'categories/:id', to: 'categories#index'
    get  'categories/subcategory/:id', to: 'categories#index_subcategory'
      
    ####PRODUCTS####
    post 'products/calc_frete', to: 'products#calc_frete'
    post 'products/favorites', to: 'products#show_favorites'
    get  'products/category/:category_id', to: 'products#show_by_category'
    get  'products/subcategory/:subcategory_id', to: 'products#show_by_subcategory'
    get  'products', to: 'products#show_all'
    get  'products/:id', to: 'products#show'
    get  'products/search/:starts_with', to: 'products#index'
    
    resources :direct_uploads, only: [:create]
  end

  scope module: :v2, constraints: ApiVersion.new('v2') do
    ####USERS####
    post 'signup', to: 'users#create'
    post 'auth/login', to: 'users#authenticate'
    post 'user/myself', to: 'users#myself'
    post 'users/forgot_password', to: 'users#forgot_password'
    post 'users/address/delete', to: 'users#destroy_address'
    post 'users/address/add', to: 'users#create_address'
    put  'users/update_password', to: 'users#update_password'
    put  'users/address/update', to: 'users#update_address'
    put  'users/:id', to: 'users#update'
    get  'users/network/users', to: 'users#load_hosted_users'

    ####ACTIVATIONS####
    post 'activations', to: 'activations#create'
    post 'activations/status', to: 'activations#activation_status'
    get  'activations', to: 'activations#index'
    get  'activations/:id', to: 'activations#show'
    post 'activations/is_first_activated', to: 'activations#first_activated?'

    ####ORDERS####
    post 'orders/calc_frete', to: 'orders#calc_frete'
    post 'orders', to: 'orders#create'
    get  'orders', to: 'orders#index'
    get  'orders/:id', to: 'orders#show'
    
    ####WITHDRAWALS####
    resources :withdrawals
    resources :bank_accounts

  end

  scope module: :v3, constraints: ApiVersion.new('v3') do
    post 'auth/login', to: 'auth#authenticate'
    delete 'attachments/:signed_id', to: 'attachments#destroy'
    resources :products do
      post 'stock', to: 'products#addStock'
      post 'stock/:id', to: 'products#updateStock'
      delete 'stock/:id', to: 'products#deleteStock'
    end
    resources :categories
    resources :subcategories
    resources :grids do
      resources :grid_variations
    end
    resources :orders
    post 'orders/:id/change-status', to: 'orders#changeStatus'
    post 'orders/:id/change-tracking-code', to: 'orders#changeTracking'
    post 'users/:id/update-point', to: 'users#update_point'
    post 'users/:id/activate', to: 'users#activate_user'
    post 'users/:id/inactivate', to: 'users#inactivate_user'
    resources :users
    resources :withdrawals
    post 'withdrawals/:id/change-status', to: 'withdrawals#changeStatus'
  end
      
  post 'paghiper_notification', to: 'paghiper_notifications#create'
  post 'mercadopago_notification', to: 'mercadopago_notifications#create'
  post 'pagarme_notification', to: 'pagarme_notifications#create'
end
