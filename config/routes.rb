Rails.application.routes.draw do
  resources :projects, only: [:index]
  resources :project_launchings, only: [:new, :create]
  resources :features, only: [:new, :create]

  resources :card_addings, only: [:create]
  resources :card_forwardings, only: [:create]

  get 'backlogs/:project_id_str', to: 'backlogs#show', as: :backlog
  get 'boards/:project_id_str', to: 'boards#show', as: :board

  root 'projects#index'
end
