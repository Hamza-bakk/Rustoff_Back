Rails.application.routes.draw do
  resources :cart
  resources :items
  resources :cart_items
  resources :user, only: :show
  resources :profiles, only: [:show, :destroy]
  
  devise_for :users,
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/member-data', to: 'members#show'
  
  post '/users/sign_in', to: 'users/sessions#create'
  delete '/users/sign_out', to: 'users/sessions#destroy', as: :custom_destroy_user_session
  
  
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
    get 'success', to: 'checkout#success', as: 'checkout_success'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
end
