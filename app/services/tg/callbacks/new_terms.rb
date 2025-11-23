module TG
  module Callbacks
    class NewTerms < Base
      # @return [void]
      def call
        first_step = Test.transaction do
          test = Test.create_from_terms_ids!(callback_payload['terms_ids'], user)

          test.next_step.tap { it.update!(status: :in_progress) }
        end

        send_message(
          chat_id: callback_query.message.chat.id,
          **step_message(first_step)
        )
      end
    end
  end
end
