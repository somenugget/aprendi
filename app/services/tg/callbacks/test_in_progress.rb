module TG
  module Callbacks
    class TestInProgress < Base
      # @return [void]
      def call
        test = user.tests.recent_in_progress.first

        if test
          go_to_next_step_or_finish!(test)
        else
          send_message(
            chat_id: callback_query.message.chat.id,
            text: 'You have no tests in progress\.'
          )
        end
      end
    end
  end
end
