class Api::BoxscoresController < ApplicationController
  before_filter :ensure_valid_league

  def show
    render json: { boxscore: boxscore }
  end

  private

  def boxscore
    @boxscore ||= Boxscore.find(params[:league_id], params[:id])
  end
end
