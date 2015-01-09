Rails.application.routes.draw do

  namespace :api do
    get "images/:path" => Dragonfly.app.endpoint { |params, app|
      size = params[:size] ? params[:size] : '70x70'
      app.fetch_file("app/assets/images/#{params[:path]}.png").thumb(size)
    }, as: 'image'

    resources :leagues, only: :index do
      resources :scores, only: :index
      resources :boxscores, only: :show
      resources :previews, only: :show
      resources :standings, only: :index
      resources :teams, only: [] do
        resource :schedule, only: :show
      end
    end
  end

end
