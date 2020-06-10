Rails.application.routes.draw do
  root 'home#index'

  resources :images
  resources :users, except: [:index]

  get 'health' => 'home#health'
  get 'zone' => 'home#zone'
  get 'version' => 'home#version'
  post 'start_unhealthy' => 'home#start_unhealthy'
  post 'start_healthy' => 'home#start_healthy'
  post 'start_load' => 'home#start_load'
end
