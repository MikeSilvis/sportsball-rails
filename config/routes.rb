Rails.application.routes.draw do

  resources :realtime_webhook, only: :create
  get 'images/:path' => redirect('not_found'), as: 'image'

  resources :leagues, only: :index do

    resources :image_downloader, only: [:update, :show, :index] do
      get :get_update
    end
    resources :scores, only: :index
    resources :boxscores, only: :show
    resources :previews, only: :show
    resources :standings, only: :index
    resources :schedules, only: :index
    resources :teams, only: [] do
      resource :schedule, only: :show
    end
  end

end
