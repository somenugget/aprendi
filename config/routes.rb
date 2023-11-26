Rails.application.routes.draw do
  get 'error/index'
  root 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?

  get :auth, to: 'auth#index'
  get :dashboard, to: 'dashboard#index'

  resources :folders do
    resources :study_sets do
      resources :terms
    end
  end

  resources :tests do
    resources :test_steps

    member do
      get :result
    end
  end

  resources :study_configs
  resources :term_progresses

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
