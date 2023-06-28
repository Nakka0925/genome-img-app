Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  root to: 'organisms#top'
  get 'download', to: 'organisms#download', as: :download
  post 'create', to: 'organisms#create', as: :create
  post 'predict', to: 'organisms#predict', as: :predict
  resources :organisms do
    collection { post :import }
  end
end
