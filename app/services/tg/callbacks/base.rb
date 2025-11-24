module TG
  module Callbacks
    class Base < BaseService
      include ::TG::StepHelpers

      # @!method bot
      # @return [Telegram::Bot::Client]
      input :bot, type: Telegram::Bot::Client

      # @!method callback_query
      # @return [Telegram::Bot::Types::CallbackQuery]
      input :callback_query, type: Telegram::Bot::Types::CallbackQuery

      # @!method user
      # @return [User]
      input :user, type: User

      private

      def test_step
        @test_step ||= TestStep.find_by(id: callback_payload['ts_id']) # rubocop:disable Rails/FindByOrAssignmentMemoization
      end

      def send_message(chat_id:, text:, parse_mode: nil, reply_markup: nil)
        bot.api.send_message(chat_id:, text:, parse_mode:, reply_markup:)
      end

      def edit_message_text(chat_id:, message_id:, text:, parse_mode: nil, reply_markup: nil)
        bot.api.edit_message_text(chat_id:, message_id:, text:, parse_mode:, reply_markup:)
      end

      def inline_keyboard_button(label:, action:, data: {})
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: label,
          callback_data: { action: }.merge(data).to_json
        )
      end

      def callback_payload
        @callback_payload ||= callback_query.data.present? ? JSON.parse(callback_query.data) : {}
      end
    end
  end
end
