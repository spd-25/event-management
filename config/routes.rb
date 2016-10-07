Rails.application.routes.draw do

  root to: 'visitors#index'
  get 'seminare(/:category_id)', to: 'seminare#index', as: :seminare_visitor
  get 'seminar/:id', to: 'seminare#show', as: :seminar_visitor
  get 'suche', to: 'seminare#search', as: :seminar_search

  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    patch 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  get 'search', to: 'search#index', as: :search

  resources :users,      except: :edit
  resources :locations,  except: :edit
  resources :teachers,   except: :edit
  resources :seminars
  resources :categories, except: :edit
  resources :bookings,   except: :edit
  resources :invoices,   except: :edit

end
