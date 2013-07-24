WishList::Application.routes.draw do
  root "welcome#index"
  resources :wishes
end
