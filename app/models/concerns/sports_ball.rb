module SportsBall
  extend ActiveSupport::Concern

  included do
    attr_accessor :league
    def name
      league.upcase
    end

    def self.available_leagues
      @allowed_sports ||= ESPN.leagues
    end

    def allowed_league?
      self.class.available_leagues.include?(league)
    end
  end
end
