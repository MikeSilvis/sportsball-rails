require 'rails_helper'

describe ScoresController, type: :controller, vcr: true do
  describe 'GET :index' do
    before do
      #allow_any_instance_of(Score).to receive(:query_with_timeout).and_return([])
      get :index, league_id: league, date: Date.new(2014, 11, 13)
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
