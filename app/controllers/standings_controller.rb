class StandingsController < ApplicationController
  def index
    render json: { standings: standings }
  end

  private

  def standings
    @standings ||= Standing.find(params[:league_id])
  end
end
