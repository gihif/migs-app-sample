Rails.application.routes.draw do
  root 'home#index'

  resources :images
  resources :users

  get 'health' => 'application#health'
end
