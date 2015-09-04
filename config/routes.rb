Rails.application.routes.draw do
  resources :projects, only: [:index]
  resources :project_launchings, only: [:new, :create]

  get 'boards/:project_id_str', to: 'boards#show', as: :board

  root 'projects#index'
end
