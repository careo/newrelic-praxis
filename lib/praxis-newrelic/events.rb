
module Praxis
  module Instrumentation
    class ControllerEvent < ::NewRelic::Agent::Instrumentation::Event
      attr_accessor :parent
      attr_reader :queue_start, :request, :controller

      def initialize(name, start, ending, transaction_id, payload, request)
        # We have a different initialize parameter list, so be explicit
        super(name, start, ending, transaction_id, payload)

        @controller = payload[:controller]
        @request = controller.request

        @queue_start = NewRelic::Agent::Instrumentation::QueueTime.parse_frontend_timestamp(request.env, self.time)
      end

      def metric_action
        self.request.action.name
      end

      def metric_name
        "Controller/#{controller.class.name}/#{metric_action}"
      end

      def ignored?
        _is_filtered?(NewRelic::Agent::Instrumentation::ControllerInstrumentation::NR_DO_NOT_TRACE_KEY)
      end

      def apdex_ignored?
        _is_filtered?(NewRelic::Agent::Instrumentation::ControllerInstrumentation::NR_IGNORE_APDEX_KEY)
      end

      # hardcoded to true for Praxis, as it makes no sense for APIs
      def enduser_ignored?
        true
      end

      def _is_filtered?(key)
        NewRelic::Agent::Instrumentation::IgnoreActions.is_filtered?(
          key,
          self.controller.class,
        self.metric_action)
      end

    end


    class RenderEvent < ::NewRelic::Agent::Instrumentation::Event

      def metric_name
        view_name = self.payload[:view].name
        blueprint_name = self.payload[:blueprint].class.name

        # mark views rendered with list of fields
        if self.payload[:fields] && self.payload[:fields].any?
          view_name << "*"
        end

        "View/#{blueprint_name}/#{view_name}/Rendering"
      end

    end

    class MapperLoadEvent < ::NewRelic::Agent::Instrumentation::Event
      def metric_name
        model_name = self.payload[:model].name

        "PraxisMapper/#{model_name}/Load"
      end
    end
  end
end
