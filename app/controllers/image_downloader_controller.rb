class ImageDownloaderController < ApplicationController
  before_filter :ensure_development

  def index
    render json: { teams: PhotoFinder::League.new(params[:league_id]).teams }
  end

  def show
    render json: { photos: PhotoFinder::Team.new({data_name: params[:id]}, team.league).photos }
  end

  def update
    photo_finder.save_by_url(params[:image_url])
  end

  private

  def ensure_development
    fail ActionController::RoutingError.new('Not Found') unless Rails.env.development?
  end

  def team
    @team ||= Team.new(team: params[:id], league: params[:league_id])
  end

  def photo_finder
    @photo_finder ||= PhotoFinder::Team.new(team, team.league)
  end
end
