Rails.application.routes.draw do
  namespace :api do
    resources :scores, only: :show
    resources :teams, only: :show
  end

  resources :scores, only: :show

  root to: 'scores#show'
end
