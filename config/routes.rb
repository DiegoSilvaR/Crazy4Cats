Rails.application.routes.draw do
  resources :comments
  resources :likes

  resources :posts, except: [:index]
  post '/posts/:id/like', to: 'posts#like', as: 'like_post'
  get "posts", to: "posts#index", as: "user_root"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  get 'home/index'

  # Defines the root path route ("/")
  root "posts#index"
end
