class TestStep < ApplicationRecord
  belongs_to :test, inverse_of: :test_steps
  belongs_to :term

  enum status: { pending: 0, in_progress: 1, successful: 2, failed: 3 }
  enum exercise: { pick_term: 0, pick_definition: 1, letters: 2, write_term: 3 }
end
