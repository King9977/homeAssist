Rails.application.routes.draw do
  
  get 'activities', to: 'activities#index'
  
  get "activities/index"
  get "home/index"
  root 'home#index'

  # Alte Seite bleibt unter /old_home zugänglich
  get 'old_home', to: 'pages#home', as: :old_home

  # Login-Routen
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Registrierungs-Routen
  get 'register', to: 'registrations#new', as: :new_registration
  post 'register', to: 'registrations#create'

  # Benutzerprofil-Routen
  get 'profile', to: 'users#show', as: :profile
  get 'profile/edit', to: 'users#edit', as: :edit_profile
  patch 'profile', to: 'users#update'

  # E-Mail-Bestätigung
  get 'confirm_email/:token', to: 'users#confirm_email', as: :confirm_email

  # Admin-Bereich Routen
  namespace :admin do
    resources :users, only: [:index, :edit, :update, :destroy]
  end

  # Admin-Erstellung
  patch 'make_admin', to: 'users#make_admin', as: :make_admin_profile

  # Gruppen-Routen
  get 'join_group', to: 'groups#join'
  post 'join_group', to: 'groups#join_group'

  # Korrigierte Gruppen-Routen mit Aufgaben und Ressourcen
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
      patch  'promote_to_admin'
      delete 'kick_user'  # DELETE request, um einen Benutzer aus der Gruppe zu entfernen
    end
  end
  
  # Routen für Kommentare zu Aufgaben
  resources :tasks do
    resources :comments, only: [:create]
  end
end
