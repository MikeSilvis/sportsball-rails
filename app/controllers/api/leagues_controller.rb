class Api::LeaguesController < ApplicationController
  skip_before_filter :ensure_valid_league

  def index
    #expires_in 7.days, public: true
    expires_now

    render json: { leagues: League.all }
  end
end
