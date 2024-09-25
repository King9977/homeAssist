Rails.application.routes.draw do
  get 'activities', to: 'activities#index'
  
  get "activities/index"
  get "home/index"
  root 'home#index'

  get 'home', to: 'pages#home', as: :home

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'register', to: 'registrations#new', as: :new_registration
  post 'register', to: 'registrations#create'

  get 'profile', to: 'users#show', as: :profile
  get 'profile/edit', to: 'users#edit', as: :edit_profile
  patch 'profile', to: 'users#update'

  get 'confirm_email/:token', to: 'users#confirm_email', as: :confirm_email

  namespace :admin do
    resources :users, only: [:index, :edit, :update, :destroy]
  end

  patch 'make_admin', to: 'users#make_admin', as: :make_admin_profile

  get 'join_group', to: 'groups#join'
  post 'join_group', to: 'groups#join_group'

  resources :groups do
    member do
      delete 'leave_group'
    end
    resources :tasks do
      member do
        patch 'update_status'
        get 'edit_status'
      end
    end
    resources :resources, except: [:show]
    member do
      patch 'promote_to_admin'
      delete 'kick_user'
    end
  end
  
  resources :tasks do
    resources :comments, only: [:create]
  end
end
