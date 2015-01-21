class SchedulesController < ApplicationController
  def show
    render json: { schedule: schedule.games }
  end

  private

  def schedule
    @schedule ||= Schedule.find(params[:league_id], params[:team_id])
  end
end
