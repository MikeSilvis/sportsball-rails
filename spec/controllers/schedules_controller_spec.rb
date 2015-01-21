require 'rails_helper'

describe SchedulesController, type: :controller, vcr: true do
  describe 'GET :show' do
    before { get :show, league_id: league, team_id: team_id }
    context 'nhl' do
      let(:league) { 'nhl' }
      let(:team_id) { 'pit' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'nfl' do
      let(:league) { 'nfl' }
      let(:team_id) { 'pit' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'ncf' do
      let(:league) { 'ncf' }
      let(:team_id) { '213' }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
