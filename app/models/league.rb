class League < QueryBase
  attr_accessor :name,
                :logo,
                :header_images,
                :header_blurred_images,
                :header_image,
                :header_blurred_image,
                :schedule,
                :monthly_schedule
  LEAGUES = [
    'nhl',
    #'nfl'
    #'ncf'
    'ncb',
    'nba',
  ]

  def initialize(name)
    self.name = name
  end

  def self.all
    LEAGUES.map do |league|
      League.new(league)
    end
  end

  def logo
    #@logo ||= api_image_url("leagues/#{name}")
    nil
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
    get_files(location).inject({}) do |hash, file|
      team_name = file.split('/').last.gsub(/.png/, '')
      hash[team_name] = api_image_url("#{name}-teams/#{location}/#{team_name}")
      hash
    end
  end

  def get_files(location)
    connection = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    connection.directories.get('jumbotron', prefix: "#{name}-teams/#{location}").files.map do |file|
      file.key
    end.select do |file|
      file.match('.png')
    end
  end

  def monthly_schedule
    %w[nhl nba ncb].include? name
  end

  def schedule
    ESPN::Schedule.find(name)
  end

  def scores(date = Date.today)
    Score.all(name, date)
  end
end
