class Standing
  attr_accessor :divisions

  def initialize(attrs)
    self.divisions = {}

    attrs.each do |division, teams|
      self.divisions[division] = teams.map do |team|
        Team.new(team)
      end
    end
  end

  def self.find(league)
    new(ESPN::Standing.find(league, ESPN::Standing::DIVISION))
  end
end
