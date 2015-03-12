require 'rails_helper'

describe ScoresController, type: :controller, vcr: true do
  describe 'GET :index' do
    let(:date) { Date.new(2014, 11, 13) }
    before do
      allow(ESPN::Score).to receive(:find).with(league, date).and_return([])
      get :index, league_id: league, date: date
    end
    context 'nhl' do
      let(:league) { 'nhl' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'nfl' do
      let(:league) { 'nfl' }
      it { expect(response).to have_http_status(:ok) }
    end
    context 'ncf' do
      let(:league) { 'ncf' }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
