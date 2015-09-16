module NewRelic::Agent::Instrumentation
  module Praxis
    module Mapper

      def self.instrument_praxis_mapper
        ::Praxis::Mapper::Query::Sequel.class_eval do

          alias_method :_execute_without_newrelic, :_execute
          def _execute(ds=nil)
            rows = nil
            NewRelic::Agent::Datastores.wrap("PraxisMapper", "select", self.model.name) do
              NewRelic::Agent.disable_all_tracing do
                rows = _execute_without_newrelic(ds)
              end
            end
            rows
          end

        end
      end
    end
  end
end
