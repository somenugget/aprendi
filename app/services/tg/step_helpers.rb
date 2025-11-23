module TG
  module StepHelpers
    # @param test [Test]
    def go_to_next_step_or_finish!(test)
      next_step = test.next_step

      if next_step.present?
        send_message(
          chat_id: callback_query.message.chat.id,
          **step_message(next_step)
        )
      else
        finish_test!(test)
      end
    end

    # @param test [Test]
    def finish_test!(test)
      test.finish_test!

      send_message(
        chat_id: callback_query.message.chat.id,
        text: '🎉 Congratulations\\! You have completed the test\\. ' \
              "Your score: *#{test.successful_steps.count}* out of *#{test.test_steps.count}*\\."
      )
    end

    # @param step [TestStep]
    # @return [Hash] attributes for send_message
    def step_message(step)
      case step.exercise
      when 'pick_term'
        pick_term_message(step)
      when 'pick_definition'
        pick_definition_message(step)
      else
        { text: "Step type #{step.exercise} not implemented yet." }
      end
    end

    # send_message attributes for the pick term step
    # @param step [TestStep]
    def pick_term_message(step)
      {
        parse_mode: 'MarkdownV2',
        text: "*#{step.term.definition}*",
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            step.terms_to_pick.map do |term|
              Telegram::Bot::Types::InlineKeyboardButton.new(text: term.term, callback_data: {
                a: 'pick_term',
                ts_id: step.id,
                tr_id: term.id
              }.to_json)
            end
          ]
        )
      }
    end

    # send_message attributes for the pick definition step
    # @param step [TestStep]
    def pick_definition_message(step)
      {
        parse_mode: 'MarkdownV2',
        text: "*#{step.term.term}*",
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            step.terms_to_pick.map do |term|
              Telegram::Bot::Types::InlineKeyboardButton.new(text: term.definition, callback_data: {
                a: 'pick_definition',
                ts_id: step.id,
                tr_id: term.id
              }.to_json)
            end
          ]
        )
      }
    end
  end
end
