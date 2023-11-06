class TestStep < ApplicationRecord
  belongs_to :test, inverse_of: :test_steps
  belongs_to :term

  enum exercise: { pick_term: 0, pick_definition: 1, letters: 2, write_term: 3 }
end
