module TG
  module Commands
    class Base < BaseService
      include ::TG::StepHelpers

      # @!method bot
      # @return [Telegram::Bot::Client]
      input :bot, type: Telegram::Bot::Client

      # @!method message
      # @return [Telegram::Bot::Types::Message]
      input :message, type: Telegram::Bot::Types::Message

      # @!method user
      # @return [User]
      input :user, type: User

      private

      def send_message(chat_id:, text:, parse_mode: nil, reply_markup: nil)
        bot.api.send_message(chat_id:, text:, parse_mode:, reply_markup:)
      end

      def inline_keyboard_button(label:, action:, data: {})
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: label,
          callback_data: { a: action }.merge(data).to_json
        )
      end
    end
  end
end
