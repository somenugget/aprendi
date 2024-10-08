Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?

  authenticate :user, ->(user) { user.email == ENV['ADMIN_EMAIL'] } do
    mount GoodJob::Engine => '/good_job'
  end

  get :dashboard, to: 'dashboard#index'

  resource :settings, only: %i[show update]

  get 'service-worker.js', to: 'service_worker#index', format: 'js'

  study_sets = proc do
    resources :study_sets do
      resource :import, only: %i[show create] do
        post :parse
      end

      resources :terms
    end
  end

  study_sets.call

  resources :push_subscriptions, only: %i[create]

  resources :folders do
    study_sets.call
  end

  resources :tests do
    resources :test_steps

    member do
      get :result
    end
  end

  resources :study_configs
  resources :term_progresses

  resource :blog, only: [] do
    get :privacy_policy
    get :terms_and_conditions
  end

  get 'data_deletion', to: 'account_deletion_requests#index'
  resources :account_deletion_requests, only: %i[index create] do
    collection do
      get :confirm
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
