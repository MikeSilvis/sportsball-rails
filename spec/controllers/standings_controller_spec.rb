require 'rails_helper'

describe StandingsController, type: :controller, vcr: true do
  describe 'GET :show' do
    before { get :index, league_id: league }
    context 'nhl' do
      let(:league) { 'nhl' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'nfl' do
      let(:league) { 'nfl' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'nba' do
      let(:league) { 'nba' }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
