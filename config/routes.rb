Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  use_doorkeeper :scope => 'oauth2'

  root :to => redirect('/home')

  ##
  # Doorkeeper
  #
  use_doorkeeper :scope => 'oauth2' do
    # accepts :authorizations, :tokens, :applications and :authorized_applications
    controllers :applications => 'my_doorkeeper/applications'

    # Don't provide authorized_applications#index
    skip_controllers :authorized_applications

  end

  match 'oauth2/authorized_application/:id' => 'my_doorkeeper/authorized_applications#destroy',
              :as => 'oauth_authorized_application',
              :via => :delete

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

  get '/home' => 'home#index'
  get '/admin' => 'admin#index'
  get '/mail' => 'mail#index'
end
