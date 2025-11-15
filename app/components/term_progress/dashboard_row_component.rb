# frozen_string_literal: true

class TermProgress::DashboardRowComponent < ApplicationComponent
  extend Dry::Initializer

  # @!method initialize(term:, success_percentage:, tests_count:, definition: nil)

  # @!method term
  # @return [String]
  option :term

  # @!method success_percentage
  # @return [Integer]
  option :success_percentage

  # @!method tests_count
  # @return [Integer]
  option :tests_count

  # @!method definition
  # @return [String, nil]
  option :definition, optional: true

  private

  def progress?
    tests_count.to_i.positive?
  end

  def progress_badge_class
    if success_percentage >= TermProgress::PERCENTAGE_THRESHOLD[:good]
      'ml-1 bg-indigo-100 text-indigo-700 text-xs font-medium me-2 px-2 py-0.5 rounded ' \
        'dark:bg-indigo-900/30 dark:text-indigo-300'
    elsif success_percentage >= TermProgress::PERCENTAGE_THRESHOLD[:medium]
      'ml-1 bg-gray-200 text-gray-700 text-xs font-medium me-2 px-2 py-0.5 rounded ' \
        'dark:bg-gray-700 dark:text-gray-300'
    else
      'ml-1 bg-gray-100 text-gray-600 text-xs font-medium me-2 px-2 py-0.5 rounded ' \
        'dark:bg-gray-800 dark:text-gray-400'
    end
  end

  def title
    "#{success_percentage}% successful out of #{pluralize(tests_count, 'test')}"
  end
end
