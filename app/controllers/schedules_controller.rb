class SchedulesController < ApplicationController
  def index
    render json: { schedules: schedules }, callback: params[:callback]
  end

  def show
    render json: { schedule: schedule.games }, callback: params[:callback]
  end

  private

  def schedule
    @schedule ||= Schedule.find(params[:league_id], params[:team_id])
  end

  def schedules
    @schedules ||= params[:teams].map { |t| Schedule.find(params[:league_id], t) }
  end
end
