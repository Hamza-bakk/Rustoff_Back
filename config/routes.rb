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

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
