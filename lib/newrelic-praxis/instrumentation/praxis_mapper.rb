DependencyDetection.defer do
  named :praxis_mapper

  depends_on do
    defined?(::Praxis) && defined?(::Praxis::Mapper)
  end

  depends_on do
    !NewRelic::Agent.config[:disable_praxis_mapper_instrumentation]
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing Praxis::Mapper instrumentation'
  end

  executes do
    require 'newrelic-praxis/praxis_mapper/helper'
    require 'newrelic-praxis/praxis_mapper/load_event'
    require 'newrelic-praxis/praxis_mapper/load_subscriber'
    require 'newrelic-praxis/praxis_mapper/finalize_subscriber'

    NewRelic::Agent::Instrumentation::Praxis::Mapper::LoadSubscriber.subscribe 'praxis.mapper.load'.freeze
    NewRelic::Agent::Instrumentation::Praxis::Mapper::FinalizeSubscriber.subscribe 'praxis.mapper.finalize'.freeze

    NewRelic::Agent::Instrumentation::Praxis::Mapper.instrument_praxis_mapper

  end
end
