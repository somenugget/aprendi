module TG
  module Commands
    class DefaultText < Base
      # @return [void]
      def call
        # test = user.tests.recent_in_progress.first

        # send_message(
        #   chat_id: message.chat.id,
        #   text: I18n.t('tg.commands.default_text.response'),
        #   parse_mode: 'MarkdownV2'
        # )
      end
    end
  end
end
