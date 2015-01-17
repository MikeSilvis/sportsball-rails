class League < QueryBase
  attr_accessor :name,
                :logo,
                :header_image,
                :header_blurred_image,
                :schedule,
                :monthly_schedule

  def initialize(name)
    self.name = name
  end

  def self.all
    [
      League.new('nhl'),
      League.new('nfl'),
      League.new('ncf')
    ]
  end

  def logo
    @logo ||= api_image_url("leagues/#{name}")
  end

  def header_image
    @header_image ||= api_image_url("leagues/#{name}-header")
  end

  def header_blurred_image
    @header_blurred_image ||= api_image_url("leagues/#{name}-header-blurred")
  end

  def monthly_schedule
    league == 'nhl'
  end

  def schedule
    ESPN::Schedule.find(name)
  end

  def scores(date = Date.today)
    Score.all(name, date)
  end
end
