Rails.application.routes.draw do
  root "dashboard#index"

  resource :session
  resources :passwords, param: :token

  # Cardápio
  resources :categories
  resources :products do
    resources :stock_movements, only: [:index, :new, :create]
  end
  resources :flavors
  resources :additionals

  # Operação
  resources :customers
  resources :dining_tables
  resources :delivery_persons

  resources :cash_registers, only: [:index, :show, :new, :create] do
    member do
      patch :close
    end
  end

  # Pedidos
  resources :orders do
    resources :order_items, only: [:create, :update, :destroy]
    resources :payments, only: [:create]
    member do
      patch :send_to_kitchen
      patch :mark_ready
      patch :start_delivery
      patch :complete
      patch :cancel
    end
  end

  # Cozinha
  get "kitchen", to: "kitchen#index", as: :kitchen

  # Busca (AJAX)
  get "products/search", to: "products#search", as: :search_products
  get "customers/search", to: "customers#search", as: :search_customers

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
