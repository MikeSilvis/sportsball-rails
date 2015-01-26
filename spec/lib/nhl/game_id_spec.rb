require 'rails_helper'

describe Nhl::GameId, vcr: true do
  describe '#find' do
    context 'gets the game id from an away team, home team and date' do
      let(:game_id) { Nhl::GameId.find('CHICAGO', 'PITTSBURGH', Date.new(2015, 1, 21)) }
      it { expect(game_id).to eq(2014020691) }
    end
  end
end
