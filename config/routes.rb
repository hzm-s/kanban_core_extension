Rails.application.routes.draw do
  resources :projects, only: [:index]
  resources :project_launchings, only: [:new, :create]
  root 'projects#index'
end
