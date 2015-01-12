require 'rails_helper'

describe League, type: :model do
  describe '.scores' do
    let(:league) { League.new('nhl') }
    let(:scores) { [score_1, score_2, score_3, score_4, score_5, score_6, score_7] }
    let(:score_1) do
      { state: 'postgame', id: 1, game_date: Date.today }
    end
    let(:score_2) do
      { state: 'pregame', start_time: '4:00 ET', id: 2, game_date: Date.today }
    end
    let(:score_3) do
      { state: 'in-progress', id: 3, progress: '1st', time_remaining: '12:43', game_date: Date.today }
    end
    let(:score_4) do
      { state: 'pregame', start_time: '3:00 ET', id: 4, game_date: Date.today }
    end
    let(:score_5) do
      { state: 'in-progress', id: 5, progress: '2nd', game_date: Date.today }
    end
    let(:score_6) do
      { state: 'in-progress', id: 6, progress: '1st', time_remaining: '3:43', game_date: Date.today }
    end
    let(:score_7) do
      { state: 'in-progress', id: 6, progress: '1st', time_remaining: '3:43', game_date: 1.day.from_now }
    end
    before { expect(Score).to receive(:query_with_timeout).and_return(scores) }
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
