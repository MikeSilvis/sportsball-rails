class Api::TeamsController < ApplicationController
  def show
    render json: teams
  end

  private

  def teams
    @teams ||= ESPN.get_teams_in(params[:id]) if valid_league?
  end

  def valid_league?
    supported_leagues.include?(params[:id])
  end

  def supported_leagues
    @supported_leagues ||= ESPN.leagues
  end
end
