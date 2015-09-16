DependencyDetection.defer do
  named :praxis_blueprints

  depends_on do
    defined?(::Praxis) && defined?(::Praxis::Blueprint)
  end

  depends_on do
    # TODO: check newrelic config for disabled stuff
    #!NewRelic::Agent.config[:disable_activerecord_instrumentation] &&
  #    !NewRelic::Agent::Instrumentation::ActiveRecordSubscriber.subscribed?
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing Praxis::Blueprint instrumentation'
  end

  executes do
    require 'newrelic-praxis/praxis_blueprint/render_event'
    require 'newrelic-praxis/praxis_blueprint/render_subscriber'

    NewRelic::Agent::Instrumentation::Praxis::Blueprint::RenderSubscriber.subscribe(/^praxis\.blueprint\.render/)
  end
end
