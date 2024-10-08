class TestStep < ApplicationRecord
  belongs_to :test, inverse_of: :test_steps
  belongs_to :term

  enum :status, { pending: 0, in_progress: 1, successful: 2, failed: 3 }
  enum :exercise, { pick_term: 0, pick_definition: 1, letters: 2, write_term: 3 }

  scope :finished, -> { where(status: %i[successful failed]) }
  scope :not_finished, -> { where.not(id: finished) }
  scope :for_term, ->(term) { where(term: term) }

  # @return [Array<Term>]
  def terms_to_pick
    (test.terms.reject { |term| term.id == term_id }.sample(3) + [term]).shuffle
  end

  # @raise [ActiveRecord::RecordInvalid]
  def register_failure!
    ApplicationRecord.transaction(requires_new: true) do
      update!(status: :failed)

      test.test_steps.create!(term: term, exercise: exercise, status: :pending)
    end
  end
end
