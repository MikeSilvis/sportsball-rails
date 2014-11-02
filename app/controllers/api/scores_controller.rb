class Api::ScoresController < ApplicationController
  def show
    render json: all_scores
  end

  private

  def all_scores
    { scores: scores.all(current_time.to_date) }
  end

  def current_time
    @current_time ||= (params[:date] ? Date.parse(params[:date]) : Time.now).in_time_zone("Eastern Time (US & Canada)").to_date
  end

  def scores
    @scores ||= begin
                  score = Score.new
                  score.league = params[:id]
                  score
                end
  end
end
