DependencyDetection.defer do
  named :praxis

  depends_on do
    defined?(::Praxis) && defined?(::Praxis::Controller)
  end

  depends_on do
    !NewRelic::Agent.config[:disable_praxis_instrumentation]
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing Praxis instrumentation'
  end

  executes do
    require 'newrelic-praxis/praxis/action_event'
    require 'newrelic-praxis/praxis/action_subscriber'

    NewRelic::Agent::Instrumentation::Praxis::ActionSubscriber.subscribe 'praxis.request_stage.execute'.freeze
  end
end
