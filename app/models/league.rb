class League < QueryBase
  attr_accessor :name,
                :logo,
                :secondary_logo,
                :header_images,
                :header_blurred_images,
                :header_image,
                :header_blurred_image,
                :schedule,
                :monthly_schedule,
                :english_name
  LEAGUES = {
    'nhl' => {
      english_name: 'NHL'
    },
    #'nfl' => {
      #english_name: 'NFL'
    #},
    #'ncf' => {
      #english_name: 'NCAAF'
    #},
    'ncb' => {
      english_name: 'NCAAB'
    },
    'nba' => {
      english_name: 'NBA'
    },
    'mlb' => {
      english_name: 'MLB'
    }
  }

  def initialize(name)
    self.name = name
  end

  def self.all
    LEAGUES.map do |league, _|
      League.new(league)
    end
  end

  def logo
    @logo ||= api_image_url("leagues/#{name}")
  end

  def secondary_logo
    @secondary_logo ||= api_image_url("leagues/secondary/#{name}")
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

  def english_name
    @english_name ||= LEAGUES[name][:english_name]
  end

  def find_images(location)
    get_files(location).inject({}) do |hash, file|
      team_name = file.split('/').last.gsub(/.png/, '')
      hash[team_name] = api_image_url("#{name}-teams/#{location}/#{team_name}")
      hash
    end
  end

  def get_files(location)
    Rails.cache.fetch("#{location}-#{name}") do
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
  end

  def monthly_schedule
    %w[nhl nba ncb mlb].include? name
  end

  def schedule
    schedule = ESPN::Schedule::League.find(name)
    schedule = schedule.concat([Date.new(2015, 4, 2), Date.new(2015, 4, 3), Date.new(2015, 4, 4)]) if name == 'mlb'
    schedule.sort
  end

  def scores(date = Date.today)
    Score.all(name, date)
  end
end
