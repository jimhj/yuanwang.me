WishList::Application.routes.draw do
  root "welcome#index"
  resources :wishes, except: :index
  resources :users
  get 'auth/weibo/callback' => 'auth#weibo_login', as: :weibo_login
end
