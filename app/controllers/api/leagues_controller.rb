class Api::LeaguesController < ApplicationController
  skip_before_filter :ensure_valid_league
  def index
    render json: { leagues: League.all }
  end
end
