Rails.application.routes.draw do
  root 'home#index'

  resources :images
  resources :users, except: [:index]

  get 'health' => 'application#health'
end
