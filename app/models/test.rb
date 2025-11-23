class Test < ApplicationRecord
  belongs_to :user

  has_many :test_steps, -> { order(:id) }, dependent: :destroy, inverse_of: :test
  has_many :terms, through: :test_steps

  enum :status, { in_progress: 0, completed: 1 }

  scope :recent_in_progress, -> { in_progress.where(created_at: 2.days.ago..) }

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

  # Get the next test step to make
  # @return [TestStep, nil]
  def next_step
    test_steps.where(status: :pending).order(id: :asc).first
  end

  # Finish test
  def finish_test!
    Test.transaction do
      update!(status: :completed)
      UpdateTermProgressAfterTestJob.perform_later(id)
      Users::UpdateStreak.call(user: user)
    end
  end
end
