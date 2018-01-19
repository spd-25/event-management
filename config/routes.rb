Rails.application.routes.draw do

  get  'buchung/:seminar_id',   to: 'buchung#new',    as: :buchung_new
  post 'buchung',               to: 'buchung#create', as: :buchung_create
  get  'nachricht/:booking_id', to: 'buchung#show',   as: :buchung_show

  resources :pages, path: 'p' do
    get :home, on: :collection
  end

  root to: 'pages#home'

  get 'seminare(/:year(/:category_id))', to: 'seminare#index',  as: :seminare_visitor
  get 'seminar/:id',                     to: 'seminare#show',   as: :seminar_visitor
  get 'suche',                           to: 'seminare#search', as: :seminar_search

  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit',   as: 'edit_user_registration'
    patch 'users'    => 'devise/registrations#update', as: 'user_registration'
  end

  namespace :admin do
    root to: 'seminars#index'

    get 'search', to: 'search#index', as: :search

    # resources(:users,     except: :edit) do
    #   get :access_rights, on: :collection
    #   get :seminars,      on: :member
    # end
    resources :locations, except: :edit
    resources(:teachers,  except: :edit) { get :seminars, on: :member }

    resources :seminars do
      member do
        get :attendees, :pras, :versions
        patch :toggle_category, :publish, :unpublish, :finish_editing, :finish_layout
      end
      collection do
        get :date, :calendar, :canceled
        get 'editing_status(/:scope)', action: :editing_status, as: :editing_status
        get 'category(/:id)',          action: :category,       as: :category
        get :search
      end
    end
    resources :categories, except: :edit do
      put :move, on: :member
    end
    resources :bookings,   only: %i[show new create]
    resources :attendees,  only: %i[index show update] do
      get :cancel
      post :cancel, action: :destroy
    end
    resources :invoices,  except: :edit
    resources :companies, except: :edit
    resources(:catalogs) { get :make_current, on: :member }

    resources :feedbacks, only: %i[new create]
  end


  resources(:users,     except: :edit) do
    get :access_rights, on: :collection
    get :seminars,      on: :member
  end
  # resources :locations, except: :edit
  # resources(:teachers,  except: :edit) { get :seminars, on: :member }

  # resources :seminars do
  #   member do
  #     get :attendees, :pras, :versions
  #     patch :toggle_category, :publish, :unpublish, :finish_editing, :finish_layout
  #   end
  #   collection do
  #     get :date, :calendar, :canceled
  #     get 'editing_status(/:scope)', action: :editing_status, as: :editing_status
  #     get 'category(/:id)',          action: :category,       as: :category
  #     get :search
  #   end
  # end
  # resources :categories, except: :edit do
  #   put :move, on: :member
  # end
  # resources :bookings,   only: %i[show new create]
  # resources :attendees,  only: %i[index show update] do
  #   get :cancel
  #   post :cancel, action: :destroy
  # end
  # resources :invoices,  except: :edit
  # resources :companies, except: :edit
  # resources(:catalogs) { get :make_current, on: :member }

  # resources :feedbacks, only: %i[new create]
end
