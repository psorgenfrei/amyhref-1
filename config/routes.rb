Rails.application.routes.draw do
  root 'home#index'

  namespace :admin do
    resources :hrefs do
      post :train, :as => :train_path
      post :untrain, :as => :untrain_path
      collection do
        get :yesterday
      end
    end
  end
end
