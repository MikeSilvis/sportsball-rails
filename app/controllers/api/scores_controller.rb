class Api::ScoresController < ApplicationController
  def index
    render json: { scores: scores }
  end

  private

  def current_time
    @current_time ||= (params[:date] ? Date.parse(params[:date]) : Time.now).in_time_zone('Pacific Time (US & Canada)').to_date
  end

  def scores
    @scores ||= league.scores(current_time.to_date)
  end

  def league
    @league ||= League.new(params[:league_id])
  end
end
