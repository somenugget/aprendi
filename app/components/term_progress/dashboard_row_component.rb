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
      'ml-1 bg-green-100 text-green-800 text-xs font-medium me-2 px-1.5 py-0.5 rounded ' \
        'dark:bg-gray-700 dark:text-green-400 border border-green-400'
    elsif success_percentage >= TermProgress::PERCENTAGE_THRESHOLD[:medium]
      'ml-1 bg-yellow-100 text-yellow-800 text-xs font-medium me-2 px-1.5 py-0.5 rounded ' \
        'dark:bg-gray-700 dark:text-yellow-300 border border-yellow-300'
    else
      'ml-1 bg-red-100 text-red-800 text-xs font-medium me-2 px-1.5 py-0.5 rounded ' \
        'dark:bg-gray-700 dark:text-red-400 border border-red-400'
    end
  end

  def title
    "#{success_percentage}% successful out of #{pluralize(tests_count, 'test')}"
  end
end
