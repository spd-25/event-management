Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :locations
  resources :teachers
  resources :seminars
  resources :categories
end
