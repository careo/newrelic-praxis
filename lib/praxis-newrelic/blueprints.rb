


class BlueprintThingy < ::NewRelic::Agent::Instrumentation::EventedSubscriber
  def start(name, id, payload) #THREAD_LOCAL_ACCESS
    event = Praxis::Instrumentation::RenderEvent.new(name, Time.now, nil, id, payload)
    push_event(event)

    state = NewRelic::Agent::TransactionState.tl_get

    if state.is_execution_traced?

      stack = state.traced_method_stack
      event.frame = stack.push_frame(state, :praxis_blueprints, event.time)
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
