class Test < ApplicationRecord
  belongs_to :user
  belongs_to :study_set

  has_many :test_steps, dependent: :destroy, inverse_of: :test

  enum status: { in_progress: 0, completed: 1 }

  class << self
    # @param [StudySet] study_set
    # @param [User] user
    def create_from_study_set(study_set, user)
      raise ArgumentError, 'Study set should have terms' if study_set.terms.empty?

      Test.transaction do
        Test.create!(user: user, status: :in_progress).tap do |test|
          study_set.terms.each do |term|
            TestStep.exercises.each_value do |exercise|
              test.test_steps.create!(term: term, exercise: exercise)
            end
          end

          test.reload
        end
      end
    end
  end

  def terms
    Term.where(id: test_steps.select(:term_id))
  end
end
