Rails.application.routes.draw do
  namespace :api do
    resources :league, only: [] do
      resources :scores, only: :index
    end
    resources :leagues, only: [] do
      resources :scores, only: :index
      resources :boxscores, only: :show
      resources :standings, only: :index
      resources :teams, only: [] do
        resource :schedule, only: :show
      end
    end
  end
end
