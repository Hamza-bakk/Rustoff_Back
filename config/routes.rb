Rails.application.routes.draw do
  resources :properties
  resources :cart
  resources :items
  resources :user, only: :show
  resources :profiles, only: [:show, :destroy]

  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  get '/member-data', to: 'members#show'

  resources :quotes, only: [:index, :new, :create, :show, :destroy] do
    member do
      post :mark, action: :mark
      post :reprocess
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
