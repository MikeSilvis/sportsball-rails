class LeaguesController < ApplicationController
  skip_before_filter :ensure_valid_league

  def index
    render json: { leagues: League.all }, callback: params[:callback]
  end
end
