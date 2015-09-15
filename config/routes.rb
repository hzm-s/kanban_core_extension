Rails.application.routes.draw do
  resources :projects, only: [:index]
  resources :project_launchings, only: [:new, :create]
  resources :features, only: [:new, :create]

  resources :card_addings, only: [:create]
  resources :card_forwardings, only: [:create]

  resources :wip_limit_changings, only: [:new, :create]
  resources :phase_spec_addings, only: [:new, :create]
  get 'phase_spec_adding/add_state', to: 'phase_spec_addings#add_state', as: :add_state_for_phase_spec_adding

  get 'backlogs/:project_id_str', to: 'backlogs#show', as: :backlog
  get 'boards/:project_id_str', to: 'boards#show', as: :board
  get 'results/:project_id_str', to: 'results#show', as: :result

  root 'projects#index'
end
