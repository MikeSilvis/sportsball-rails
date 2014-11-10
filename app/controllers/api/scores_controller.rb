class Api::ScoresController < ApplicationController
  before_filter :require_valid_league

  def show
    render json: { scores: scores.all(current_time.to_date) }
  end

  private

  def require_valid_league
    render json: false unless scores.allowed_league?
  end

  def current_time
    @current_time ||= (params[:date] ? Date.parse(params[:date]) : Time.now).in_time_zone('Pacific Time (US & Canada)').to_date
  end

  def scores
    @scores ||= begin
                  score = Score.new
                  score.league = params[:id]
                  score
                end
  end
end
