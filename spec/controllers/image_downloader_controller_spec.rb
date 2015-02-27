require 'rails_helper'

describe ImageDownloaderController, type: :controller do
  describe 'POST :create' do
    before { allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development')) }
    context 'nhl' do
      let(:image_url) { 'http://mikesilvis.com/assets/mikesilvis-5618db47c32a7e5a2db00f8a3b36d958.png' }
      let(:data_name) { 'pitt' }
      before do
        expect_any_instance_of(Team).to receive(:download_logo).with(image_url)
        post :create, league_id: 'nhl', image_url: image_url, data_name: data_name
      end
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
