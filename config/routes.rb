Rails.application.routes.draw do
  resources :scores, only: :show

  namespace :api do
    resources :scores, only: :show
  end

  root to: 'scores#show'
end
