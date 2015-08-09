class LeaguesController < ApplicationController
  skip_before_filter :ensure_valid_league

  def index
    expires_in 1.day, public: true

    render json: { leagues: leagues }, callback: params[:callback]
  end

  private

  def leagues
    League.all
  end
end
