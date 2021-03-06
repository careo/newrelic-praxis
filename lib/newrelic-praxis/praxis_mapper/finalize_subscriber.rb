module NewRelic
  module Agent
    module Instrumentation
      module Praxis
        module Mapper

          class FinalizeSubscriber < EventedSubscriber

            def start(name, id, payload) #THREAD_LOCAL_ACCESS
              event = Event.new(name, Time.now, nil, id, payload)
              push_event(event)

              state = TransactionState.tl_get

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

              state = TransactionState.tl_get

              if state.is_execution_traced?
                stack = state.traced_method_stack
                stack.pop_frame(state, event.frame, 'Custom/PraxisMapper/Finalize', event.end)
              end
            rescue => e
              log_notification_error(e, name, 'finish')
            end

          end
        end
      end
    end
  end
end
