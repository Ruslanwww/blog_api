Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  root 'posts#index'

  resources :posts

  get 'profiles/:id/subscriptions_list' => 'profiles#subscriptions_list', as: 'profile_subscriptions'
  get 'profiles/:id/subscribers_list' => 'profiles#subscribers_list', as: 'profile_subscribers'

  get 'profiles/friends_posts'

  get '/search' => 'profiles#search_users', as: 'search_profile'

  get '/post/:id/like' => 'posts#like', as: 'like_post'

  get 'profiles/:id' => 'profiles#show', as: 'profile'
  get 'profiles/:id/posts' => 'profiles#show_user_posts', as: 'profile_posts'

  get 'profiles/:id/subscribe' => 'profiles#subscribe', as: 'profile_subscribe'
  get 'profiles/:id/unsubscribe' => 'profiles#unsubscribe', as: 'profile_unsubscribe'

  get 'profile/recommendations' => 'profiles#subscription_recommendations', as: 'profile_recommendations'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
