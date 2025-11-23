module TG
  class Dispatcher < BaseService
    # @!method bot
    # @return [Telegram::Bot::Client]
    input :bot, type: Telegram::Bot::Client

    # @!method update
    # @return [Telegram::Bot::Types::Update]
    input :update, type: Telegram::Bot::Types::Update

    # @return [void]
    def call # rubocop:disable Metrics/AbcSize
      user = find_user(from.id)

      if message.present?
        resolve_message_handler(message.text).call(bot:, user:, message:)
      elsif callback_query.present?
        resolve_callback_handler(callback_query.data).call(bot:, user:, callback_query:)
      end
    end

    private

    def from
      message&.from || callback_query&.from
    end

    def message
      update.message || update.edited_message
    end

    def callback_query
      update.callback_query
    end

    def handler_class
      if message.present?
        resolve_message_handler(message.text)
      elsif callback_query.present?
        resolve_callback_handler(update.data)
      end
    end

    def resolve_message_handler(text)
      class_name = text.start_with?('/') ? text.split.first.delete_prefix('/').camelize : 'DefaultText'

      "TG::Commands::#{class_name}".safe_constantize || Telegram::Commands::Fallback
    end

    def resolve_callback_handler(data)
      payload = JSON.parse(data)
      action = payload['a']
      class_name = action.camelize

      "TG::Callbacks::#{class_name}".safe_constantize
    end

    def find_user(tg_user_id)
      Authorization.find_by(uid: tg_user_id, provider: 'telegram')&.user
    end
  end
end
