# frozen_string_literal: true

class UI::EmptyStateComponent < ApplicationComponent
  extend Dry::Initializer

  # @!method message
  # @return [String]
  option :message

  # @!method action_text
  # @return [String]
  option :action_text

  # @!method action_href
  # @return [String]
  option :action_href

  # @!method wrapper_class
  # @return [String]
  option :wrapper_class, default: proc {}

  private

  def panel_class
    class_names(
      'rounded-lg border border-dashed border-gray-300 dark:border-gray-600',
      'bg-gray-50/80 dark:bg-gray-800/40 px-6 py-14 text-center',
      wrapper_class
    )
  end
end
