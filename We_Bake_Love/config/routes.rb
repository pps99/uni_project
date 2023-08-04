Rails.application.routes.draw do
  resources :admin_order_lists
  resources :user_details
  get "/accept", to: "user_details#accept"
  get "/cancel", to: "user_details#cancel"

  get "carts/show"
  resources :cakes do
    collection { post :import }
  end

  resources :cart_items
  resource :carts

  root "home_page#index"
  # Home
  get "emptyCart", to: "carts#emptyCart"
  get "emptyUser", to: "carts#emptyUser"
  get "home_page", to: "home_page#index"
  get "/search", to: "home_page#search"
  get "/carts", to: "carts_controller#show"
  get "/cancel_cart_item", to: "cart_items#cancel"
  resources :users
  post "/login", to: "users#validate_login"
  get '/user', to: 'users#auto_login'
  post "/logout", to: 'users#logout'
  post '/cakes/search', to: 'cakes#search'

  get "/send_mail", to: "posts#send_mail"
  get "/promote", to: "users#promote"
  get "/degrade", to: "users#degrade"
  get "/logout", to: "users#logout"
  get "/viewer", to: "users#viewer"
  post "/search_database", to: "users#search"
  get "/search_database", to: "users#index"
  get "/handle_login", to: "users#handle_login"
  post "password/reset", to: "password_resets#create"
  get "password/reset_save", to: "password_resets#edit"
  post "password/reset_save", to: "password_resets#update"

  get '/items', to: "cakes#get_items"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
