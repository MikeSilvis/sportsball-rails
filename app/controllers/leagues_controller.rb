class LeaguesController < ApplicationController
  skip_before_filter :ensure_valid_league

  def index
    expires_in 1.day, public: true

    render json: { leagues: leagues }, callback: params[:callback]
  end

  private

  def leagues
    ## TODO: REMOVE AFTER ONE MONTH OF RELEASE
    if params[:version].to_f == 1.3
      League.all
    else
      League.all.select { |league| league.enabled? }
    end
  end
end
