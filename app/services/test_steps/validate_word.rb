module TestSteps
  class ValidateWord < BaseService
    # @!method test_step
    #   @return [TestStep]
    input :test_step, type: TestStep

    # @!method answer
    #   @return [String]
    input :answer, type: String

    # @return [Boolean]
    def call
      fail!(error: "\"#{answer.strip}\" does not match \"#{test_step.term.term.strip}\"") unless words_match?
    end

    private

    def words_match?
      I18n.transliterate(answer.strip).downcase == I18n.transliterate(test_step.term.term.strip).downcase
    end
  end
end
