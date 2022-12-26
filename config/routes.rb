Rails.application.routes.draw do
  root to: 'organisms#top'
  get 'database', to: 'organisms#database_show', as: :database_show
  post 'create', to: 'organisms#create', as: :create
  resources :organisms do
    collection { post :import }
  end
end
