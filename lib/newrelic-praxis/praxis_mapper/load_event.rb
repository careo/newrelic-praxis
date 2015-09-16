module NewRelic::Agent::Instrumentation
  module Praxis
    module Mapper
      class LoadEvent < Event
        def metric_name
          model_name = self.payload[:model].name

          "PraxisMapper/#{model_name}/Load"
        end
      end
    end
  end
end
