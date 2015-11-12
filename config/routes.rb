Rails.application.routes.draw do

  root :to => redirect('/home')

  devise_for :users,
    :controllers => {:sessions => 'sessions'},
    :skip => [:registrations, :unlocks]
  devise_for :services,
    :controllers => {:sessions => 'sessions'},
    :skip => [:registrations, :unlocks, :session, :password]

  resources :notifications, :only => [:index, :show, :destroy]
  match :notifications, :to => 'notifications#destroy_all', :via => :delete

  resources :groups do
    resources :users, :controller => 'group_users', :only => [:create, :destroy]
    resources :services, :controller => 'group_services', :only => [:create, :destroy]
  end

  resources :roles
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
  get '/mail' => 'mail#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
