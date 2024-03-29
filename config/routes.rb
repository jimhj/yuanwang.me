WishList::Application.routes.draw do
  root "welcome#index"
  resources :wishes, except: :index do
    collection do
      post :upload
      get :duoshuo_comments
    end

    member do
      post :grant
      post :confirm_grant

    end
  end

  resources :users
  resources :notifications, only: [:index, :show, :destroy]
  get 'auth/weibo/callback' => 'auth#weibo_login', as: :weibo_login
  get 'sign_out' => 'auth#sign_out', :as => :sign_out
end
