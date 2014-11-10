require 'benchmark/ips'

namespace :speed do
  desc "Compares various sport providers API response time"
  task :check => :environment do
    Benchmark.ips do |x|
      # Configure the number of seconds used during
      # the warmup phase (default 2) and calculation phase (default 5)
      x.config(:time => 5, :warmup => 2)

      # These parameters can also be configured this way
      x.time = 5
      x.warmup = 2

      x.report("Yahoo: ncf") do
        Faraday.get 'http://sports.yahoo.com/college-football/scoreboard/?conf=fbs_all'
      end

      x.report("Yahoo: nhl") do
        Faraday.get 'http://sports.yahoo.com/nfl/scoreboard/'
      end

      x.report("Yahoo: nfl") do
        Faraday.get 'http://sports.yahoo.com/nfl/scoreboard/'
      end

      x.report("CBS: ncf") do
        Faraday.get 'http://www.cbssports.com/collegefootball/scoreboard/FBS/2014/week11'
      end

      x.report("CBS: nhl") do
        Faraday.get 'http://www.cbssports.com/nhl/scoreboard'
      end

      x.report("CBS: nfl") do
        Faraday.get 'http://www.cbssports.com/nfl/scoreboard'
      end

      x.report("ESPN: ncf") do
        Faraday.get 'http://scores.espn.go.com/college-football/scoreboard?seasonYear=2014&seasonType=2&weekNumber=11&confId=80'
      end

      x.report("ESPN: nhl") do
        Faraday.get 'http://scores.espn.go.com/nhl/scoreboard'
      end

      x.report("ESPN: nfl") do
        Faraday.get 'http://scores.espn.go.com/nhl/scoreboard'
      end

      x.compare!
    end
  end
end

