# frozen_string_literal: true

class UI::Form::SelectComponent < ApplicationComponent
  extend Dry::Initializer

  # @!method initialize(form:, attribute:, options: {}, label_options: {}, errors: [])

  # @!method form
  #  @return [ActionView::Helpers::FormBuilder]
  option :form

  # @!method attribute
  #  @return [Symbol]
  option :attribute

  # @!method values
  #  @return [Array]
  option :values, default: proc { [] }

  # @!method options
  #  @return [Hash]
  option :options, default: proc { {} }

  # @!method label_options
  #  @return [Hash]
  option :label_options, default: proc { {} }

  # @!method errors
  #  @return [Array<String>]
  option :errors, default: proc { [] }

  private

  def label_class
    'block mb-2 text-sm font-medium text-gray-900 dark:text-white'
  end

  def input_class
    class_names(
      'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500',
      options[:class],
      'border-red-500': errors.any?
    )
  end

  def error_class
    'mt-1 text-sm text-red-600 dark:text-red-500'
  end
end
