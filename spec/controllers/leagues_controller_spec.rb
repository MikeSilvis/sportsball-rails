require 'rails_helper'

describe LeaguesController, type: :controller, vcr: true do
  before do
    allow_any_instance_of(League).to receive(:schedule).and_return([])
  end

  describe 'GET :index' do
    before { get :index }
      it { expect(response).to have_http_status(:ok) }
  end
end
