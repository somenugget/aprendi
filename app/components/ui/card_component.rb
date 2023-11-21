# frozen_string_literal: true

class UI::CardComponent < ApplicationComponent
  include ActionView::Helpers::TagHelper

  attr_reader :attributes

  def initialize(**attributes)
    @attributes = attributes
  end

  def as
    attributes[:as] || :div
  end

  def card_class
    class_names(
      'block max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-100 dark:bg-gray-800 dark:border-gray-700 dark:hover:bg-gray-700',
      attributes[:class]
    )
  end
end
