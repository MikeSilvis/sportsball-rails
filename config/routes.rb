Rails.application.routes.draw do
  namespace :api do
    resources :scores, only: :show
  end
end
