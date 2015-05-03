class ApplicationController < ActionController::API
  before_filter :fix_college
  before_filter :ensure_valid_league
  after_filter  :remove_cookies

  def available_leagues
    @allowed_sports ||= ESPN.leagues
  end

  def fix_college
    params[:league_id] = 'ncf' if params[:league_id] == 'college-football'
    params[:league_id] = 'ncb' if params[:league_id] == 'mens-college-basketball'
  end

  def ensure_valid_league
    fail ActionController::RoutingError.new('Not Found') unless available_leagues.include?(params[:league_id])
  end

  def remove_cookies
    request.session_options[:skip] = true
  end
end
