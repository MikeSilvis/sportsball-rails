require 'rails_helper'

describe BoxscoresController, type: :controller, vcr: true do
  describe 'GET :show' do
    before { get :show, league_id: league, id: boxscore_id }
    context 'nhl' do
      let(:league) { 'nhl' }
      let(:boxscore_id) { '400564807' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'nfl' do
      let(:league) { 'nfl' }
      let(:boxscore_id) { '400554422' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'ncf' do
      let(:league) { 'ncf' }
      let(:boxscore_id) { '400609076' }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
