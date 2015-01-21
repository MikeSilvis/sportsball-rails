require 'rails_helper'

describe LeaguesController, type: :controller, vcr: true do
  describe 'GET :index' do
    before { get :index }
      it { expect(response).to have_http_status(:ok) }
  end
end
