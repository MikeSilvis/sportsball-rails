class PreviewsController < ApplicationController
  def show
    render json: { preview: preview }
  end

  private

  def preview
    @preview ||= Preview.find(params[:league_id], params[:id])
  end
end
