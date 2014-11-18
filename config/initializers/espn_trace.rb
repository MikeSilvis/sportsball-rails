module ESPN
  class << self
    include ::NewRelic::Agent::MethodTracer

    add_method_tracer :get, 'ESPN/get'

    add_method_tracer :visitor_home_parse, 'ESPN/visitor_home_parse'
    add_method_tracer :winner_loser_parse, 'ESPN/winner_loser_parse'
  end
end
