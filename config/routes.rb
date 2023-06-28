Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  root to: 'organisms#top'
  get 'download', to: 'organisms#download', as: :download
  post 'create', to: 'organisms#create', as: :create
  post 'predict', to: 'organisms#predict', as: :predict
  resources :organisms do
    collection { post :import }
  end
end
