require 'rails_helper'

describe Nhl::Recap, vcr: true do
  describe '#find' do
    context 'get data for the NHL' do
      let(:recap) { Nhl::Recap.find(2014020691) }
      it { expect(recap[:headline]).to eq('Senators hand Maple Leafs sixth straight loss') }
      it { expect(recap[:content].size).to eq(4411) }
    end
  end
end
