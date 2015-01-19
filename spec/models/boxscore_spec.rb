require 'rails_helper'

describe Boxscore, type: :model, vcr: true do
  describe '.recap' do
    let(:boxscore) { Boxscore.find('nhl', 400564392) }
    context 'before game is over' do
      before { expect(boxscore).to receive(:state).and_return('in-pgoress') }
      it { expect(boxscore.recap).to be_nil }
    end
    context 'once game is over but recap doesnt exist yet' do
      before { expect_any_instance_of(Recap).to receive(:headline).and_return('No recap available') }
      it { expect(boxscore.recap).to be_nil }
    end
    context 'if there is a recap' do
      it { expect(boxscore.recap).to be_kind_of(Recap) }
    end
  end
end
