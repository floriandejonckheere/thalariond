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
    :skip => [:registrations, :unlocks]
  devise_for :services,
    :controllers => {
      :sessions => 'my_devise/sessions'
    },
    :skip => [:registrations, :unlocks, :session, :password]

  ##
  # Resources
  #
  resources :notifications, :only => [:index, :show, :destroy]
  match 'notifications' => 'notifications#destroy_all', :as => :destroy_notifications, :via => :delete
  match 'notifications' => 'notifications#update_all', :as => :update_notifications, :via => :patch

  resources :groups do
    resources :users, :controller => 'group_users', :only => [:create, :destroy]
    resources :services, :controller => 'group_services', :only => [:create, :destroy]
  end

  resources :roles, :only => [:index, :show]
  resources :users do
    resources :roles, :controller => 'user_roles', :only => [:create, :destroy]
    post :unlock, :on => :member
  end
  resources :services do
    resources :roles, :controller => 'service_roles', :only => [:create, :destroy]
    post :reset, :on => :member
  end

  resources :domains do
    resources :emails, :except => :index
  end
  resources :domain_aliases, :controller => 'domain_aliases', :except => :index
  resources :email_aliases, :controller => 'email_aliases', :except => :index

  # Additional routes for a new email without predefined domain
  get '/emails/new' => 'emails#new_blank', :as => 'new_email'
  post '/emails' => 'emails#create'

  get '/home' => 'home#index'
  get '/admin' => 'admin#index'
  get '/mail' => 'mail#index'
end
