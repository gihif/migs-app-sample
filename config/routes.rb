require 'sidekiq/web'

Rails.application.routes.draw do
  root 'home#index'
  mount Sidekiq::Web => '/sidekiq'

  resources :images
  resources :users, except: [:index]

  get 'health' => 'home#health'
  get 'zone' => 'home#zone'
  get 'version' => 'home#version'
  get 'dbinfo' => 'home#dbinfo'
  post 'start_unhealthy' => 'home#start_unhealthy'
  post 'start_healthy' => 'home#start_healthy'
  post 'start_load' => 'home#start_load'
  post 'start_failover' => 'home#start_failover'
end
