class Api::ScoresController < ApplicationController
  def show
    render json: all_scores
  end

  private

  def all_scores
    Rails.cache.fetch("nhl-#{current_time}") do
      { scores: scores.all(current_time.to_date) }
    end
  end

  def current_time
    @current_time ||= (params[:date] ? Date.parse(params[:date]) : 1.day.ago).in_time_zone("Eastern Time (US & Canada)")
  end

  def scores
    @scores ||= begin
                  score = Score.new
                  score.league = params[:id]
                  score
                end
  end
end
