require 'rails_helper'

describe ImageDownloaderController, type: :controller, vcr: true do
  before { allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development')) }
  let(:response_body) { JSON.parse(response.body) }

  describe 'POST :update' do
    context 'nhl' do
      let(:image_url) { 'http://mikesilvis.com/assets/mikesilvis-5618db47c32a7e5a2db00f8a3b36d958.png' }
      let(:id) { 'pitt' }
      before do
        expect_any_instance_of(PhotoFinder::Team).to receive(:save_by_url).with(image_url)
        put :update, league_id: 'nhl', image_url: image_url, id: id
      end
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'GET :show' do
    before { get :show, league_id: 'nhl', id: 'chi' }
    it { expect(response).to have_http_status(:ok) }
    it { expect(response_body['photos'].length).to eq(7) }
  end

  describe 'GET :index' do
    before { get :index, league_id: 'nhl' }
    it { expect(response_body['teams'].length).to eq(30) }
  end
end
