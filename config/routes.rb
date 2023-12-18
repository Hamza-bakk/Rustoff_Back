Rails.application.routes.draw do
  resources :cart do 
    member do
      delete 'item/:item_id', to: 'cart#destroy_item', as: 'cart_item'
    end
  end
  
  resources :items
  resources :cart_items
  resources :orders, only: [:show, :index]
  resources :user, only: :show
  resources :profiles, only: [:show, :update, :destroy]
  
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/edit_password' 
    }
  get '/member-data', to: 'members#show'
  
  post '/users/sign_in', to: 'users/sessions#create'
  delete '/users/sign_out', to: 'users/sessions#destroy', as: :custom_destroy_user_session
  put '/users/edit_password/update/:id', to: 'users/edit_password#update', as: 'update_user_password'
  
  
  get '/users', to: 'users#index'
  namespace :api do
    namespace :v1 do
      get '/user_stats', to: 'dashboard#user_stats'
      get '/quote_stats', to: 'dashboard#quote_stats'
      get '/processed_quotes_count', to: 'dashboard#processed_quotes_count'
      get '/unprocessed_quotes_count', to: 'dashboard#unprocessed_quotes_count'
      get '/order_stats', to: 'dashboard#order_stats'
      get '/item_stats', to: 'dashboard#item_stats'
      get '/recent_orders', to: 'dashboard#recent_orders'
      get '/users', to: 'dashboard#users'
      get '/orders', to: 'dashboard#users'
    end
  end
  
  resources :quotes, only: [:index, :update, :destroy, :new, :create] do
    member do
      put 'mark', to: 'quotes#mark'
      put 'reprocess', to: 'quotes#reprocess'
      delete 'destroy', to: 'quotes#destroy'
    end
  end

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    post 'order', to: 'checkout#order', as: 'checkout_order'
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
end
