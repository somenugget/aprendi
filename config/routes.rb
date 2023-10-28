Rails.application.routes.draw do
  resources :term_progresses
  resources :test_steps
  resources :tests
  resources :terms
  resources :study_configs
  resources :study_sets
  resources :folders
  root 'home#index'

  get :auth, to: 'auth#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
