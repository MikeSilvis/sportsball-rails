class Api::ScoresController < ApplicationController
  def show
    render json: scores
  end

  private

  def allowed_sports
    @allowed_sports ||= ESPN.leagues
  end

  def scores
    @scores ||= begin
                  ESPN.public_send("get_#{params[:id]}_scores", Date.today) if allowed_sport?
                end
  end

  def allowed_sport?
    allowed_sports.include?(params[:id])
  end

end
