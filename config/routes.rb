Rails.application.routes.draw do
  resources :projects, only: [:index]
  resources :project_launchings, only: [:new, :create]
  resources :features, only: [:new, :create]

  resources :card_addings, only: [:create]
  resources :card_forwardings, only: [:create]

  resources :wip_limit_changings, only: [:new, :create]
  resources :phase_spec_addings, only: [:new, :create]
  resources :transition_settings, only: [:new, :create]

  get 'backlogs/:project_id_str', to: 'backlogs#show', as: :backlog
  get 'boards/:project_id_str', to: 'boards#show', as: :board
  get 'results/:project_id_str', to: 'results#show', as: :result

  get 'input_fields/new_transition', to: 'input_fields#new_transition', as: :new_transition_input_field
  get 'input_fields/new_state', to: 'input_fields#new_state', as: :new_state_input_field

  root 'projects#index'
end
