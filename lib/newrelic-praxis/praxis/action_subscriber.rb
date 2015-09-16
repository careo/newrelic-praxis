module NewRelic
  module Agent
    module Instrumentation
      module Praxis

        class ActionSubscriber < EventedSubscriber

          def start(name, id, payload) #THREAD_LOCAL_ACCESS
            state = TransactionState.tl_get

            controller = payload[:controller]
            request = controller.request

            event = ActionEvent.new(name, Time.now, nil, id, payload, request)
            push_event(event)

            if state.is_execution_traced? && !event.ignored?
              start_transaction(state, event)
            else
              # if this transaction is ignored, make sure child
              # transaction are also ignored
              state.current_transaction.ignore! if state.current_transaction
              NewRelic::Agent.instance.push_trace_execution_flag(false)
            end
          rescue => e
            log_notification_error(e, name, 'start')
          end

          def finish(name, id, payload) #THREAD_LOCAL_ACCESS
            event = pop_event(id)
            event.payload.merge!(payload)

            state = TransactionState.tl_get

            request = event.request
            attributes = {:'request.parameters' => request.params_hash}
            attributes.merge!(
              :'request.api_version' => request.version
            )

            NewRelic::Agent.add_custom_attributes(attributes)

            if state.is_execution_traced? && !event.ignored?
              stop_transaction(state, event)
            else
              NewRelic::Agent.instance.pop_trace_execution_flag
            end
          rescue => e
            log_notification_error(e, name, 'finish')
          end

          def start_transaction(state, event)
            Transaction.start(state, :controller,
              :transaction_name => event.metric_name,
              :apdex_start_time => event.queue_start
            )
          end

          def stop_transaction(state, event=nil)
            txn = state.current_transaction
            txn.ignore_apdex!   if event.apdex_ignored?
            txn.ignore_enduser! if event.enduser_ignored?
            Transaction.stop(state)
          end

        end
      end
    end
  end
end
