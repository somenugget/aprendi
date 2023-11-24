class Test < ApplicationRecord
  belongs_to :user

  has_many :test_steps, dependent: :destroy, inverse_of: :test

  enum status: { in_progress: 0, completed: 1 }

  class << self
    # @param [StudySet] study_set
    # @param [User] user
    def create_from_study_set!(study_set, user)
      raise ArgumentError, 'Study set should have terms' if study_set.terms.empty?

      Test.transaction do
        Test.create!(user: user, status: :in_progress).tap do |test|
          TestStep.exercises.each_value do |exercise|
            study_set.terms.shuffle.each do |term|
              test.test_steps.create!(term: term, exercise: exercise)
            end
          end

          test.reload
        end
      end
    end

    # @param [Enumerable<Integer>] terms_ids
    # @param [User] user
    def create_from_terms_ids!(terms_ids, user)
      Test.transaction do
        Test.create!(user: user, status: :in_progress).tap do |test|
          TestStep.exercises.each_value do |exercise|
            terms_ids.shuffle.each do |term_id|
              test.test_steps.create!(term_id: term_id, exercise: exercise)
            end
          end

          test.reload
        end
      end
    end
  end

  # @return [ActiveRecord::Relation<Term>]
  def terms
    Term.where(id: test_steps.select(:term_id))
  end
end
