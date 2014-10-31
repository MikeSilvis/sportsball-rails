Rails.application.routes.draw do
  namespace :api do
    resources :scores, only: :show
    resources :teams, only: :show
  end
end
