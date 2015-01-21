require 'rails_helper'

describe TeamImageCsvGenerator, vcr: true do
  let(:generator) { TeamImageCsvGenerator.new('nhl') }
  context 'finds all teams in league' do
    it { expect(generator.teams.size).to eq(30) }
  end
end

