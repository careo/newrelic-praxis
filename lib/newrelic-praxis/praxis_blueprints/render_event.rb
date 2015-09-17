module NewRelic::Agent::Instrumentation
  module Praxis
    module Blueprint
      class RenderEvent < Event

        def metric_name
          view_name = self.payload[:view].name
          blueprint_name = self.payload[:blueprint].class.name

          # mark views rendered with list of fields
          if self.payload[:fields] && self.payload[:fields].any?
            view_name = "#{view_name}*"
          end

          "View/#{blueprint_name}/#{view_name}/Rendering"
        end

      end

    end
  end

end
