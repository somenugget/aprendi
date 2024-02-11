module TestSteps
  class ValidateWord < BaseService
    include NormalizeWord

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
      normalize_word(answer) == normalize_word(test_step.term.term)
    end
  end
end
