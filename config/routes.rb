WishList::Application.routes.draw do
  root "welcome#index"
  resources :wishes, except: :index
  resources :users
end
