# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => redirect('/home')

  ##
  # NGINX Authentication route
  #
  get '/auth' => 'application#auth'

  ##
  # Devise
  #
  devise_for :users,
             :controllers => {
               :sessions => 'my_devise/sessions',
               :confirmations => 'my_devise/confirmations',
               :passwords => 'my_devise/passwords'
             },
             :skip => %i[registrations unlocks]
  devise_for :services,
             :controllers => {
               :sessions => 'my_devise/sessions'
             },
             :skip => %i[registrations unlocks session password]

  ##
  # Resources
  #
  resources :notifications, :only => %i[index show destroy]
  match 'notifications' => 'notifications#destroy_all', :as => :destroy_notifications, :via => :delete
  match 'notifications' => 'notifications#update_all', :as => :update_notifications, :via => :patch

  resources :groups do
    resources :users, :controller => 'group_users', :only => %i[create destroy]
    resources :services, :controller => 'group_services', :only => %i[create destroy]
  end

  resources :roles, :only => %i[index show]
  resources :users do
    resources :roles, :controller => 'user_roles', :only => %i[create destroy]
    post :unlock, :on => :member
  end
  resources :services do
    resources :roles, :controller => 'service_roles', :only => %i[create destroy]
    post :reset, :on => :member
  end

  get '/home' => 'home#index'
  get '/admin' => 'admin#index'
  get '/mail' => 'mail#index'
end
