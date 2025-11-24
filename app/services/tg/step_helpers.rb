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
      when 'letters'
        letters_message(step)
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

    # send_message attributes for the letters picking step
    # @param step [TestStep]
    def letters_message(step)
      {
        parse_mode: 'MarkdownV2',
        text: "Translate \"*#{step.term.definition}*\" using the letters below:\n",
        reply_markup: letters_sliced_keyboard(step.term.chars_to_guess_with_indexes.shuffle, { ts_id: step.id })
      }
    end

    # inline keyboard for the letters picking step
    # @param chars [Array<Hash>] array of chars with indexes
    def letters_sliced_keyboard(chars, data = {})
      Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard:
          chars.each_slice(8).map do |chars_slice|
            chars_slice.map do |char|
              Telegram::Bot::Types::InlineKeyboardButton.new(text: char[:char], callback_data: {
                a: 'letters',
                lt: char[:char],
                i: char[:index],
                **data
              }.to_json)
            end.compact
          end
      )
    end
  end
end
