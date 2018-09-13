Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  root 'posts#index'

  resources :posts

  get '/search' => 'profiles#search_users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
