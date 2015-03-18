class Standing
  attr_accessor :divisions, :league, :headers

  def initialize(attrs)
    self.divisions = {}
    self.league    = attrs[:league]
    self.headers   = attrs[:headers]

    attrs[:teams].each do |division, teams|
      self.divisions[division] = teams.map do |team|
        Team.new(team)
      end
    end
  end

  def self.find(league)
    new(ESPN::Standing.find(league, ESPN::Standing::DIVISION))
  end
end
