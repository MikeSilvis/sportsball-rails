class ApplicationController < ActionController::API
  before_filter :ensure_valid_league

  def available_leagues
    @allowed_sports ||= ESPN.leagues
  end

  def ensure_valid_league
    unless available_leagues.include?(params[:league_id])
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
