class ScoresController < ApplicationController
  def index
    render json: { scores: scores }
  end

  private

  def current_time
    @current_time ||= date.in_time_zone(time_zone).to_date
  end

  def date
    @date ||= params[:date] ? Date.parse(params[:date]) : Time.now
  end

  def scores
    @scores ||= league.scores(current_time.to_date)
  end

  def time_zone
    params[:time_zone] ? params[:time_zone] : 'Pacific Time (US & Canada)'
  end

  def league
    @league ||= League.new(params[:league_id])
  end
end
