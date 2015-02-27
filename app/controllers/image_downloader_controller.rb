class ImageDownloaderController < ApplicationController
  before_filter :ensure_development

  def create
    team.download_logo(params[:image_url])
  end

  private

  def ensure_development
    fail ActionController::RoutingError.new('Not Found') unless Rails.env.development?
  end

  def team
    @team ||= Team.new(team: params[:data_name], league: params[:league_id])
  end
end
