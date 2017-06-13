Rails.application.routes.draw do

  get 'buchung/:seminar_id', to: 'buchung#new', as: :buchung_new
  post 'buchung',      to: 'buchung#create', as: :buchung_create
  get 'nachricht/:booking_id', to: 'buchung#show', as: :buchung_show

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
  resources :teachers,   except: :edit do
    get :seminars, on: :member
  end
  resources :seminars do
    member do
      get :attendees, :pras, :versions
      patch :toggle_category
    end
    collection do
      get :date, :calendar, :canceled
      get 'category(/:id)', action: :category, as: :category
      get :search
    end
  end
  resources :categories, except: :edit do
    put :move, on: :member
  end
  resources :bookings,   only: %i(show new create)
  resources :attendees,  only: %i(index show update destroy) do
    get :cancel
  end
  resources :invoices,   except: :edit
  resources :companies,  except: :edit
  resources :catalogs do
    get :make_current, on: :member
  end

end
