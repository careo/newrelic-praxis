require 'newrelic_rpm'
# require 'new_relic/agent/method_tracer'
# class Foo
#   include ::NewRelic::Agent::MethodTracer
#
#   def generate_image
#   end
#
#   add_method_tracer :generate_image, 'Custom/generate_image'
# end
require 'praxis-mapper'

require 'praxis-newrelic/events'

require 'praxis-newrelic/mapper'
require 'praxis-newrelic/blueprints'
require 'praxis-newrelic/controller'


module Praxis
  module NewRelic
    def self.start
      ActionThingy.subscribe(/^praxis\.request_stage\.execute/)
      BlueprintThingy.subscribe(/^praxis\.blueprint\.render/)

      MapperLoadThingy.subscribe 'praxis.mapper.load'
      MapperFinalizeThingy.subscribe 'praxis.mapper.finalize'
    end
  end
end
