class League < QueryBase
  attr_accessor :name,
                :logo,
                :header_images,
                :header_blurred_images,
                :header_image,
                :header_blurred_image,
                :schedule,
                :monthly_schedule

  def initialize(name)
    self.name = name
  end

  def self.all
    %w[nhl nfl ncb nba ncf].map do |league|
      League.new(league)
    end
  end

  def logo
    @logo ||= api_image_url("leagues/#{name}")
  end

  # TODO: Remove upon submitting new build
  def header_image
    @header_image ||= header_images.values.first
  end

  # TODO: Remove upon submitting new build
  def header_blurred_image
    @header_blurred_image ||= header_blurred_images.values.first
  end

  def header_images
    @header_images ||= find_images('headers')
  end

  def header_blurred_images
    @header_blurred_images ||= find_images('blurred-headers')
  end

  def find_images(location)
    Dir["#{Rails.root}/app/assets/images/#{name}-teams/#{location}/*.png"].inject({}) do |hash, file|
      team_name = file.split('/').last.gsub(/.png/, '')
      hash[team_name] = api_image_url("#{name}-teams/#{location}/#{team_name}")
      hash
    end
  end

  def monthly_schedule
    name == 'nhl'
  end

  def schedule
    ESPN::Schedule.find(name)
  end

  def scores(date = Date.today)
    Score.all(name, date)
  end
end
