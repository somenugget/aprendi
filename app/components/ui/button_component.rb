# frozen_string_literal: true

class UI::ButtonComponent < ApplicationComponent
  extend Dry::Initializer

  # @!method initialize(variant: :primary, text: nil, size: :md, icon: nil, icon_position: :left, options: {})

  option :variant, default: proc { :primary }

  option :text, default: proc {}

  option :size, default: proc { :md }

  option :icon, default: proc {}

  option :icon_position, default: proc { :left }

  option :options, default: proc { {} }

  COLOR_CLASSES = {
    primary: 'transition text-white bg-linear-to-br from-purple-600 to-blue-500 hover:bg-linear-to-bl ' \
             'focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800 ' \
             'dark:bg-gradient-to-br dark:from-purple-800 dark:to-blue-700',

    secondary: 'text-white bg-linear-to-r from-cyan-500 to-blue-500 hover:bg-linear-to-bl ' \
               'focus:ring-4 focus:outline-none focus:ring-cyan-300 dark:focus:ring-cyan-800 ' \
               'dark:bg-gradient-to-r dark:from-cyan-700 dark:to-blue-600',

    danger: 'text-white bg-linear-to-br from-pink-600 to-orange-400 hover:bg-linear-to-bl ' \
            'focus:ring-4 focus:outline-none focus:ring-pink-200 dark:focus:ring-pink-800 ' \
            'dark:bg-gradient-to-br dark:from-pink-800 dark:to-orange-600',

    warning: 'text-white bg-linear-to-r from-red-500 via-red-400 to-yellow-300 hover:bg-linear-to-bl ' \
             'focus:ring-4 focus:outline-none focus:ring-red-100 dark:focus:ring-red-400 ' \
             'dark:bg-gradient-to-r dark:from-red-600 dark:via-red-500 dark:to-yellow-400',

    success: 'text-gray-900 bg-linear-to-r from-teal-200 to-lime-200 ' \
             'hover:bg-linear-to-l hover:from-teal-200 hover:to-lime-200 ' \
             'focus:ring-4 focus:outline-none focus:ring-lime-200 dark:focus:ring-teal-700 ' \
             'dark:text-white dark:bg-gradient-to-r dark:from-teal-700 dark:to-lime-600 ' \
             'dark:hover:bg-gradient-to-l dark:hover:from-teal-800 dark:hover:to-lime-700',

    neutral: 'text-gray-900 bg-linear-to-r from-indigo-50 to-cyan-50 ' \
             'hover:bg-linear-to-l hover:from-indigo-50 hover:to-cyan-50 ' \
             'focus:ring-4 focus:outline-none focus:ring-cyan-200 dark:focus:ring-teal-700 ' \
             'dark:text-white dark:bg-gradient-to-r dark:from-gray-800 dark:to-gray-700 ' \
             'dark:hover:bg-gradient-to-l dark:hover:from-gray-900 dark:hover:to-gray-800'
  }.freeze

  SIZE_CLASSES = {
    xs: 'gap-1 px-3 py-2 text-xs',
    sm: 'gap-1 px-3 py-2 text-sm',
    md: 'gap-1 px-5 py-2.5 text-sm',
    lg: 'gap-2 px-5 py-3 text-base',
    xl: 'gap-2 px-6 py-3.5 text-lg'
  }.freeze

  ICON_SIZE_CLASSES = {
    xs: 'w-3! h-3!',
    sm: 'w-4! h-4!',
    md: 'w-4! h-4!',
    lg: 'w-6! h-6!',
    xl: 'w-7! h-7!'
  }.freeze

  private

  def render?
    raise ArgumentError, 'Text or block must be provided' if text.blank? && !content?

    true
  end

  def as
    options[:as] || :button
  end

  def html_class
    class_names('cursor-pointer', color_class, layout_class, size_class, options[:class])
  end

  def size_class
    SIZE_CLASSES[size.to_sym]
  end

  def layout_class
    class_names('rounded-lg text-center inline-flex items-center disabled:pointer-events-none disabled:opacity-50',
                'flex-row-reverse' => icon_position == :right)
  end

  def color_class
    COLOR_CLASSES[variant.to_sym]
  end

  def icon_class
    return '' if icon.blank?

    class_names(ICON_SIZE_CLASSES[size.to_sym])
  end
end
