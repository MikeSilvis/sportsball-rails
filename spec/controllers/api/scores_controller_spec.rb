require 'rails_helper'

describe Api::ScoresController, :type => :controller, vcr: true do
  describe 'GET :index' do
    before { get :index, league_id: league, date: Date.new(2014, 11, 13) }
    context 'nhl' do
      let(:league) { 'nhl' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'nfl' do
      let(:league) { 'nfl' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'ncf' do
      let(:league) { 'nfl' }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
