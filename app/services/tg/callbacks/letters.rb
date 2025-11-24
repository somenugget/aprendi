module TG
  module Callbacks
    class Letters < Base
      include NormalizeWord

      # @return [void]
      def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        return if button_has_been_handled?

        text, word = extract_message_text_and_word

        next_unguessed_char, word_with_next_chars = extract_next_unguessed_char(word)

        if normalize_word(next_unguessed_char) == normalize_word(selected_letter)
          rest_keyboard_chars = prev_keyboard_chars.reject { it[:index] == callback_payload['i'] }
          word = word_with_next_chars
        else
          rest_keyboard_chars = prev_keyboard_chars
          # mark it as failed here to know about the mistake on the final step
          test_step.failed!
        end

        if prev_keyboard_chars.present?
          edit_message_text(
            chat_id: callback_query.message.chat.id,
            message_id: callback_query.message.message_id,
            text: "#{text}\n>#{word}",
            parse_mode: 'MarkdownV2',
            reply_markup: letters_sliced_keyboard(rest_keyboard_chars, { ts_id: test_step.id })
          )
        else
          finalise_test_step!

          go_to_next_step_or_finish!(test_step.test)
        end
      end

      private

      def prev_keyboard_chars
        @prev_keyboard_chars ||= callback_query
                                 .message
                                 .reply_markup
                                 .inline_keyboard
                                 .to_a
                                 .flatten
                                 .map { { char: it.text, index: JSON.parse(it.callback_data)['i'] } }
      end

      def button_has_been_handled?
        prev_keyboard_chars.find { it[:index] == callback_payload['i'] }.nil?
      end

      def selected_letter
        callback_payload['lt']
      end

      def extract_message_text_and_word
        text, word = callback_query.message.text.split("\n")
        word = '' if word.nil?

        [text, word]
      end

      def extract_next_unguessed_char(word)
        term = test_step.term.term

        word_with_next_chars = word.dup
        next_unguessed_char = nil
        loop do
          next_unguessed_char = term.chars[word_with_next_chars.length]
          break if next_unguessed_char.nil?

          word_with_next_chars += next_unguessed_char

          break if Term.char_to_guess?(next_unguessed_char)
        end

        [next_unguessed_char, word_with_next_chars]
      end

      def finalise_test_step!
        # call register_failure! to create copy of this step in the future
        if test_step.failed?
          test_step.register_failure!
        else
          test_step.update!(status: :successful)
        end
      end
    end
  end
end
