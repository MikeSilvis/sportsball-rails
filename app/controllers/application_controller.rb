class ApplicationController < ActionController::API
  before_filter :ensure_valid_league

  def available_leagues
    @allowed_sports ||= ESPN.leagues
  end

  def ensure_valid_league
    fail ActionController::RoutingError.new('Not Found') unless available_leagues.include?(params[:league_id])
  end
end
