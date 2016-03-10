Rails.application.routes.draw do
  root 'home#index'

  resources :sessions
  get "/auth/:provider/callback" => 'sessions#create'
  delete "/signout" => 'sessions#destroy'

  match '/you/newsletters/:newsletter_id(/:page)', :to => 'you#newsletters', :as => 'you_newsletter', :via => :get
  match '/you/search(/:page)', :to => 'you#search', :as => 'you_search', :via => :get
  match '/you(/:page)', :to => 'you#index', :as => 'you', :via => :get, :constraints => { :id => /\d/ }

  namespace :admin do
    resources :hrefs do
      post :train, :as => :train_path
      collection do
        get :search
        get :today
        get :yesterday
      end
    end
  end

  #get '*archives' => 'home#archives'
end
