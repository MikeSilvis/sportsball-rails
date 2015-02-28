Rails.application.routes.draw do

  get "images/:path" => Dragonfly.app.endpoint { |params, app|
    size = params[:size] ? params[:size] : '70x70'
    path = QueryBase.decode_path(params[:path])
    app.fetch_url("https://s3.amazonaws.com/jumbotron/#{path}.png").thumb(size)
  }, as: 'image'

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
