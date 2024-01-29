class UI::Form::ToggleComponent < ApplicationComponent
  extend Dry::Initializer

  # @!method form
  #  @return [ActionView::Helpers::FormBuilder]
  option :form

  # @!method attribute
  #  @return [Symbol]
  option :attribute

  # @!method label
  # @return [String]
  option :label, default: proc {}

  # @!method options
  #  @return [Hash]
  option :options, default: proc { {} }

  # @!method options
  #  @return [Hash]
  option :checkbox_options, default: proc { {} }
end
