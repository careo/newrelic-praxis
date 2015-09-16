
module Praxis::Mapper
  module Query
    class Sequel

      alias_method :_execute_without_newrelic, :_execute

      #def _execute(ds=nil)
      #  metric_name = "Datastore/statement/PraxisMapper/#{self.model.name}/select"
      #  NewRelic::Agent::MethodTracer.trace_execution_scoped([metric_name]) do
      #    NewRelic::Agent.disable_all_tracing do
      #      _execute_without_newrelic(ds)
      #    end
      #  end
      #end

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




class MapperLoadThingy < ::NewRelic::Agent::Instrumentation::EventedSubscriber
  def start(name, id, payload) #THREAD_LOCAL_ACCESS
    event = Praxis::Instrumentation::MapperLoadEvent.new(name, Time.now, nil, id, payload)
    push_event(event)

    state = NewRelic::Agent::TransactionState.tl_get

    if state.is_execution_traced?
      stack = state.traced_method_stack
      event.frame = stack.push_frame(state, :praxis_mapper, event.time)
    end
  rescue => e
    log_notification_error(e, name, 'start')
  end

  def finish(name, id, payload) #THREAD_LOCAL_ACCESS
    event = pop_event(id)
    event.payload.merge!(payload)

    state = NewRelic::Agent::TransactionState.tl_get

    if state.is_execution_traced?
      stack = state.traced_method_stack
      frame = stack.pop_frame(state, event.frame, event.metric_name, event.end)
      record_metrics(event, frame)
    end
  rescue => e
    log_notification_error(e, name, 'finish')
  end

  # TODO: todo?
  def record_metrics(event,frame)
  end

end

class MapperFinalizeThingy < ::NewRelic::Agent::Instrumentation::EventedSubscriber
  def start(name, id, payload) #THREAD_LOCAL_ACCESS
    event =  NewRelic::Agent::Instrumentation::Event.new(name, Time.now, nil, id, payload)
    push_event(event)

    state = NewRelic::Agent::TransactionState.tl_get

    if state.is_execution_traced?
      stack = state.traced_method_stack
      event.frame = stack.push_frame(state, :praxis_mapper, event.time)
    end
  rescue => e
    log_notification_error(e, name, 'start')
  end

  def finish(name, id, payload) #THREAD_LOCAL_ACCESS
    event = pop_event(id)
    event.payload.merge!(payload)

    state = NewRelic::Agent::TransactionState.tl_get

    if state.is_execution_traced?
      stack = state.traced_method_stack
      frame = stack.pop_frame(state, event.frame, 'Custom/PraxisMapper/Finalize', event.end)
      record_metrics(event, frame)
    end
  rescue => e
    log_notification_error(e, name, 'finish')
  end

  # TODO: todo?
  def record_metrics(event,frame)
  end

end
