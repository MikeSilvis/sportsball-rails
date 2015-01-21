class BoxscoresController < ApplicationController
  def show
    render json: { boxscore: boxscore }
  end

  private

  def boxscore
    @boxscore ||= Boxscore.find(params[:league_id], params[:id])
  end
end
