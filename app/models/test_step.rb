class TestStep < ApplicationRecord
  belongs_to :test
  belongs_to :term
end
