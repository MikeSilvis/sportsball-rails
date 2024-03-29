class League < QueryBase
  attr_accessor :name,
                :logo,
                :header_images,
                :schedule,
                :monthly_schedule,
                :english_name,
                :enabled
  LEAGUES = {
    'nhl' => {
      english_name: 'NHL',
      enabled: false
    },
    'nfl' => {
      english_name: 'NFL',
      enabled: true
    },
    'ncf' => {
      english_name: 'NCAAF',
      enabled: true
    },
    'ncb' => {
      english_name: 'NCAAB',
      enabled: false
    },
    'nba' => {
      english_name: 'NBA',
      enabled: false
    },
    'mlb' => {
      english_name: 'MLB',
      enabled: true
    }
  }

  def initialize(name)
    self.name = name
  end

  def self.all
    LEAGUES.map do |league, _|
      League.new(league)
    end.sort_by { |league| league.enabled? ? 0 : 1 }
  end

  def logo
    @logo ||= api_image_url("leagues/#{name}")
  end

  def header_images
    @header_images ||= find_images('headers')
  end

  def english_name
    @english_name ||= LEAGUES[name][:english_name]
  end

  def enabled
    @enabled ||= LEAGUES[name][:enabled]
  end

  def enabled?
    enabled
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
    enabled ? ESPN::Schedule::League.find(name).sort : []
  end

  def scores(date = Date.today)
    Score.all(name, date)
  end
end
