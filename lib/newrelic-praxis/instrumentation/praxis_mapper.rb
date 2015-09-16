DependencyDetection.defer do
  named :praxis_mapper

  depends_on do
    defined?(::Praxis) && defined?(::Praxis::Mapper)
  end

  depends_on do
    # TODO: check newrelic config for disabled stuff
    #!NewRelic::Agent.config[:disable_activerecord_instrumentation] &&
  #    !NewRelic::Agent::Instrumentation::ActiveRecordSubscriber.subscribed?
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing Praxis::Mapper instrumentation'
  end

  executes do
    require 'newrelic-praxis/mapper/helper'

    require 'newrelic-praxis/mapper/load_event'
    require 'newrelic-praxis/mapper/load_subscriber'

    require 'newrelic-praxis/mapper/finalize_subscriber'

    NewRelic::Agent::Instrumentation::Praxis::Mapper::LoadSubscriber.subscribe 'praxis.mapper.load'
    NewRelic::Agent::Instrumentation::Praxis::Mapper::FinalizeSubscriber.subscribe 'praxis.mapper.finalize'

    NewRelic::Agent::Instrumentation::Praxis::Mapper.instrument_praxis_mapper

  end
end
