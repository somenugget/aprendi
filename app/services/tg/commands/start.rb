module TG
  module Commands
    class Start < Base
      # @return [void]
      def call
        send_message(
          chat_id: message.chat.id,
          text: response,
          parse_mode: 'MarkdownV2',
          reply_markup:
        )
      end

      private

      def test_in_progress
        @test_in_progress ||= user.tests.recent_in_progress.first
      end

      def response
        response_parts = available_categories.values.map do |terms|
          title = "*#{terms[:label]}:*"
          list = terms[:terms].map do |term|
            "#{term.term} \\- #{term.definition}"
          end.join("\n")

          "#{title}\n#{list}"
        end + [test_in_progress.present? ? test_in_progress_text : nil]

        response_parts.compact.join("\n\n")
      end

      def reply_markup
        Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            available_categories.map do |key, terms|
              inline_keyboard_button(label: terms[:label], action: key, data: { terms_ids: terms[:terms].map(&:id) })
            end + (test_in_progress.present? ? [test_in_progress_button] : [])
          ]
        )
      end

      def available_categories # rubocop:disable Metrics/AbcSize
        @available_categories ||= {
          ripening: {
            label: 'Ripening Terms',
            terms: RipeningTermsQuery.new(user:).relation.limit(5).load
          },
          new_terms: {
            label: 'New Terms',
            terms: NewTermsQuery.new(user:).relation.order(:created_at).limit(5).load
          },
          ripe_terms: {
            label: 'Ripe Terms',
            terms: DashboardRipeTermsQuery.new(user:, total_records: 5).relation
          }
        }.reject { |_, terms| terms[:terms].empty? }
      end

      def test_in_progress_text
        '📝 You also have a test in progress\\. ' \
          "You have *#{test_in_progress.test_steps.not_finished.count}* " \
          "of *#{test_in_progress.test_steps.count}* steps unfinished\\.\n"
      end

      def test_in_progress_button
        inline_keyboard_button(label: 'Continue Test', action: 'test_in_progress')
      end
    end
  end
end
