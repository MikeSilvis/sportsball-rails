Rails.application.routes.draw do
  namespace :api do
    resources :league, only: [] do
      resources :scores, only: :index
    end
    resources :leagues, only: [] do
      resources :scores, only: :index
      resources :boxscores, only: :show
    end
  end
end
