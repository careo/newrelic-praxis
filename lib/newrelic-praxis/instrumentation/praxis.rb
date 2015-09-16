DependencyDetection.defer do
  named :praxis

  depends_on do
    defined?(::Praxis) && defined?(::Praxis::Controller)
  end

  depends_on do
    # TODO: check newrelic config for disabled stuff
    #!NewRelic::Agent.config[:disable_activerecord_instrumentation] &&
  #    !NewRelic::Agent::Instrumentation::ActiveRecordSubscriber.subscribed?
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing Praxis instrumentation'
  end

  executes do
    require 'newrelic-praxis/praxis/action_event'
    require 'newrelic-praxis/praxis/action_subscriber'

    NewRelic::Agent::Instrumentation::Praxis::ActionSubscriber.subscribe(/^praxis\.request_stage\.execute/)
  end
end
