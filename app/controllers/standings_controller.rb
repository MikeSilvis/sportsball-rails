class StandingsController < ApplicationController
  def index
    render json: { standings: standings }, callback: params[:callback]
  end

  private

  def standings
    @standings ||= Standing.find(params[:league_id])
  end
end
