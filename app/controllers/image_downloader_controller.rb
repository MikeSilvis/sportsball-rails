class ImageDownloaderController < ApplicationController
  before_filter :ensure_development
  before_filter :add_id

  def index
    render json: { teams: teams }, callback: params[:callback]
  end

  def show
    render json: { photos: PhotoFinder::Team.new({data_name: params[:id]}, team.league).photos }, callback: params[:callback]
  end

  def update
    photo_finder.save_by_url(params[:image_url])
  end

  def get_update
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
    @photo_finder ||= PhotoFinder::Team.new({data_name: params[:id]}, team.league)
  end

  def teams
    @teams ||= begin
                 PhotoFinder::League.new(params[:league_id]).teams.reject do |team|
                   PhotoFinder::Team.new({data_name: team[:data_name]}, params[:league_id]).has_photo?
                 end
               end
  end

  def add_id
    params[:id] = params[:image_downloader_id] if params[:image_downloader_id].present?
  end
end
