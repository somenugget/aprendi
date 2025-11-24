module TG
  module Callbacks
    class PickTerm < Base
      # @return [void]
      def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        selected_term = Term.find(callback_payload['tr_id'])
        test = test_step.test

        if test_step.term == selected_term
          test_step.update(status: :successful)
          response_text = "Correct\\! *#{test_step.term.definition}* \\- *#{test_step.term.term}*"
        else
          test_step.register_failure!
          response_text = "Almost there\\! *#{test_step.term.definition}* \\- *#{test_step.term.term}*"
        end

        edit_message_text(
          chat_id: callback_query.message.chat.id,
          message_id: callback_query.message.message_id,
          text: response_text,
          parse_mode: 'MarkdownV2'
        )

        go_to_next_step_or_finish!(test)
      rescue Telegram::Bot::Exceptions::ResponseError => e
        if e.message.include?('message is not modified')
          Rails.logger.error e.message
          return
        end

        raise e
      end
    end
  end
end
