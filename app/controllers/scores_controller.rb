class ScoresController < ApplicationController
  def show
  end

  private

  def scores
    @scores ||= begin
                  score = Score.new
                  score.league = params[:id]
                  score
                end
  end
  helper_method :scores

  def teams
    @teams ||= begin
                 teams = Team.new
                 teams.league = params[:id]
                 teams
               end
  end
  helper_method :teams

  def dates
    @dates ||= [
      4.days.ago.to_date,
      3.days.ago.to_date,
      2.days.ago.to_date,
      1.day.ago.to_date
    ]
  end
  helper_method :dates

  def current_date
     params[:date] ? Date.parse(params[:date]) : Date.today
  end
  helper_method :current_date
end
