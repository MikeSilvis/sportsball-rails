Rails.application.routes.draw do
  namespace :api do
    resources :league, only: [] do
      resources :scores, only: :index
    end

    resources :leagues, only: [] do
      get "image/:team" => Dragonfly.app.endpoint { |params, app|
        size = params[:size] ? params[:size] : '60x60'
        app.fetch_file("app/assets/images/#{params[:league_id]}-teams/#{params[:team]}.png").thumb(size)
      }, as: 'team_logo'

      resources :scores, only: :index
      resources :boxscores, only: :show
      resources :standings, only: :index
      resources :teams, only: [] do
        resource :schedule, only: :show
      end
    end
  end
end
