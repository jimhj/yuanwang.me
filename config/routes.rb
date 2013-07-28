WishList::Application.routes.draw do
  root "welcome#index"
  resources :wishes, except: :index do
    collection do
      post :upload
    end

    member do
      post :grant
    end
  end
  resources :users
  get 'auth/weibo/callback' => 'auth#weibo_login', as: :weibo_login
end
