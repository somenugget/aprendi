# frozen_string_literal: true

class UI::CardComponent < ApplicationComponent
  include ActionView::Helpers::TagHelper

  COLOR_CLASSES = {
    primary: 'border-purple-200 shadow-purple-500/30',
    secondary: 'border-blue-200 shadow-blue-500/30',
    danger: 'border-red-200 shadow-red-500/30',
    warning: 'border-yellow-200 shadow-yellow-500/30',
    success: 'border-lime-200 shadow-lime-500/30',
    neutral: 'border-gray-200 shadow-gray-500/20',
    default: 'border-gray-200'
  }.freeze

  CLICKABLE_COLOR_CLASSES = {
    primary: 'hover:bg-purple-50/50 dark:hover:bg-purple-700',
    secondary: 'hover:bg-blue-50/50 dark:hover:bg-blue-700',
    danger: 'hover:bg-red-50/50 dark:hover:bg-red-700',
    warning: 'hover:bg-yellow-50/50 dark:hover:bg-yellow-700',
    success: 'hover:bg-lime-50/50 dark:hover:bg-lime-700',
    neutral: 'hover:bg-gray-50/50 dark:hover:bg-gray-700',
    default: 'hover:bg-gray-50/50 dark:hover:bg-gray-700'
  }.freeze

  attr_reader :options

  def initialize(**options)
    @options = options
  end

  private

  def color_class
    COLOR_CLASSES[variant.to_sym]
  end

  def variant
    options[:variant] || :default
  end

  def as
    options[:as] || :div
  end

  def clickable?
    as.in?(%i[a button])
  end

  def clickable_class
    CLICKABLE_COLOR_CLASSES[variant.to_sym] if clickable?
  end

  def card_class
    class_names(
      'block max-w-sm p-3 md:p-6 bg-white border rounded-lg ' \
      'shadow dark:text-gray-100 dark:bg-gray-800 dark:border-gray-700',
      clickable_class,
      color_class,
      options[:class]
    )
  end
end
