require 'new_relic/agent/method_tracer'

module SportsBall
  extend ActiveSupport::Concern
  include ::NewRelic::Agent::MethodTracer

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
