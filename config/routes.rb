Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    patch 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  get 'search', to: 'search#index', as: :search

  resources :users
  resources :locations
  resources :teachers
  resources :seminars
  resources :categories
end
