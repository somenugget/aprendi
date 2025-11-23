# rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
module TG
  class TelegramBot < BaseService
    include Rails.application.routes.url_helpers

    input :bot, type: Telegram::Bot::Client
    input :update, type: [Telegram::Bot::Types::Message, Telegram::Bot::Types::CallbackQuery]

    # @return [void]
    def call
      user = Authorization.find_by(uid: message.from.id, provider: 'telegram')&.user

      if user
        respond_existing_user(user)
      else
        respond_new_user
      end
    end

    private

    def respond_existing_user(user)
      case message
      when Telegram::Bot::Types::Message
        respond_existing_user_message(user)
      when Telegram::Bot::Types::CallbackQuery
        callback_payload = JSON.parse(message.data)

        case callback_payload['action']
        when 'ripening'
          bot.api.send_message(
            chat_id: message.chat.id,
            text: 'To be done',
            parse_mode: 'MarkdownV2',
            reply_markup:
          )
        when 'new'
          test = Test.create_from_terms_ids!(callback_payload['terms_ids'], user)
          first_step = test.next_step
          first_step.update!(status: :in_progress)

          if first_step.pick_term?
            response = "*#{first_step.term.definition}*"
            reply_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
              inline_keyboard: [
                first_step.terms_to_pick.map do |term|
                  Telegram::Bot::Types::InlineKeyboardButton.new(text: term.term, callback_data: {
                    action: 'answer_pick_term',
                    test_step_id: first_step.id,
                    term_id: term.id
                  }.to_json)
                end
              ]
            )

            bot.api.send_message(
              chat_id: message.message.chat.id,
              text: response,
              parse_mode: 'MarkdownV2',
              reply_markup:
            )
          end
        when 'answer_pick_term'
          test_step = TestStep.find(callback_payload['test_step_id'])
          selected_term = Term.find(callback_payload['term_id'])

          if test_step.term == selected_term
            bot.api.edit_message_text(
              chat_id: message.message.chat.id,
              message_id: message.message.message_id,
              text: "Correct\\! The term is *#{test_step.term.term}*",
              parse_mode: 'MarkdownV2'
            )

            # TODO: go to the next step
          end
        end
      end
    end

    def respond_existing_user_message(user)
      case message.text
      when '/start dashboard', '/dashboard', '/start'
        dashboard(user)
      when '/login'
        login
      when '/help'
        help
      else
        default
      end
    end

    def respond_new_user
      case message.text
      when '/start'
        new_user_start
      when '/login'
        login
      when '/help'
        help
      else
        default
      end
    end

    def dashboard(user)
      available_categories = {
        ripening: {
          label: 'Ripening Terms',
          terms: RipeningTermsQuery.new(user:).relation.limit(5).load
        },
        new: {
          label: 'New Terms',
          terms: NewTermsQuery.new(user:).relation.order(:created_at).limit(5).load
        },
        ripe: {
          label: 'Ripe Terms',
          terms: DashboardRipeTermsQuery.new(user:).relation
        }
      }.reject { |_, terms| terms[:terms].empty? }

      response = available_categories.values.map do |terms|
        title = "*#{terms[:label]}:*"
        list = terms[:terms].map do |term|
          "#{term.term} \\- #{term.definition}"
        end.join("\n")

        "#{title}\n#{list}"
      end.compact.join("\n\n")

      reply_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [
          available_categories.map do |key, terms|
            Telegram::Bot::Types::InlineKeyboardButton.new(text: terms[:label], callback_data: {
              action: key,
              terms_ids: terms[:terms].map(&:id)
            }.to_json)
          end
        ]
      )

      # byebug

      bot.api.send_message(
        chat_id: message.chat.id,
        text: response,
        parse_mode: 'MarkdownV2',
        reply_markup:
      )
    end

    # TODO: use InlineKeyboardMarkup for the link
    def login
      user_token = UserAuthToken.create_with_token(meta: { telegram_user_id: message.from.id })

      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Follow this link to login via the web app #{new_user_session_url(token: user_token)}"
      )
    end

    def new_user_start
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Hello, #{message.from.first_name}! Welcome to the bot. Please use /login to link your account."
      )
    end

    def help
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Available commands:\n/start - Start the bot\n/login - Get a login link\n/help - Show this help message"
      )
    end

    def default
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "I don't understand that command. Type /help for assistance."
      )
    end
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
