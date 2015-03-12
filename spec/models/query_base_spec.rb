require 'rails_helper'

describe League, type: :model, vcr: true do
  describe '.decode_path' do
    context 'with the most current URL' do
      let(:url) { QueryBase.encode_path("hello") }
      it { expect(QueryBase.decode_path(url)).to eq("hello.png") }
    end
    context 'with an old URL' do
      let(:url) { "hello-#{QueryBase::ASSET_HASHES.first}.png" }
      it { expect(QueryBase.decode_path(url)).to eq("hello.png") }
    end
  end
end
