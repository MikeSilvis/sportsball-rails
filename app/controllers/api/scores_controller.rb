class Api::ScoresController < ApplicationController
  def show
    render json: { scores: scores.all(1.day.ago.to_date) }
  end

  private

  def scores
    @scores ||= begin
                  score = Score.new
                  score.league = params[:id]
                  score
                end
  end
end
