Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users

  get 'search', to: 'search#index', as: :search

  resources :locations
  resources :teachers
  resources :seminars
  resources :categories
end
