require 'rails_helper'

describe League, type: :model do
  describe '.scores' do
    let(:league) { League.new('nhl') }
    let(:scores) { [score_1, score_2, score_3, score_4, score_5, score_6] }
    let(:score_1) {
      { state: 'postgame', id: 1 }
    }
    let(:score_2) {
      { state: 'pregame', start_time: '4:00 ET', id: 2 }
    }
    let(:score_3) {
      { state: 'in-progress', id: 3, progress: '1st', time_remaining: '12:43' }
    }
    let(:score_4) {
      { state: 'pregame', start_time: '3:00 ET', id: 4 }
    }
    let(:score_5) {
      { state: 'in-progress', id: 5, progress: '2nd' }
    }
    let(:score_6) {
      { state: 'in-progress', id: 6, progress: '1st', time_remaining: '3:43' }
    }
    before { expect(league).to receive(:query_espn).and_return(scores) }
    let(:score_order) { league.scores.map(&:id) }
    it 'sorts the games by state, time, & duration' do
      expect(score_order).to eq([
        5,
        6,
        3,
        4,
        2,
        1
      ])
    end
  end
end
