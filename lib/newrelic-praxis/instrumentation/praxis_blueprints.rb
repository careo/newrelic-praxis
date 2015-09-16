DependencyDetection.defer do
  named :praxis_blueprints

  depends_on do
    defined?(::Praxis) && defined?(::Praxis::Blueprint)
  end

  depends_on do
    !NewRelic::Agent.config[:disable_praxis_blueprints_instrumentation]
  end


  executes do
    ::NewRelic::Agent.logger.info 'Installing Praxis::Blueprint instrumentation'
  end

  executes do
    require 'newrelic-praxis/praxis_blueprints/render_event'
    require 'newrelic-praxis/praxis_blueprints/render_subscriber'

    NewRelic::Agent::Instrumentation::Praxis::Blueprint::RenderSubscriber.subscribe 'praxis.blueprint.render'.freeze
  end
end
