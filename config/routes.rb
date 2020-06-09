Rails.application.routes.draw do
  root 'home#index'

  resources :images
  resources :users, except: [:index]

  get 'health' => 'application#health'
  get 'zone' => 'application#zone'
  get 'version' => 'application#version'
  post 'start_unhealthy' => 'application#start_unhealthy'
  post 'start_load' => 'application#start_load'
end
