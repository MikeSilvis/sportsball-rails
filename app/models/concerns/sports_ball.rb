module SportsBall
  extend ActiveSupport::Concern

  included do
    attr_accessor :league

    def available_leagues
      @allowed_sports ||= ESPN.leagues
    end

    def allowed_sport?
      available_leagues.include?(league)
    end
  end
end
