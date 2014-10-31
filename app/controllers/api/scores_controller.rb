class Api::ScoresController < ApplicationController
  def show
    render json: all_scores
  end

  private

  def all_scores
    Rails.cache.fetch("nhl-#{1.day.ago}") do
      { scores: scores.all(1.day.ago.to_date) }
    end
  end

  def scores
    @scores ||= begin
                  score = Score.new
                  score.league = params[:id]
                  score
                end
  end
end
