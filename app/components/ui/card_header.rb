class UI::CardHeader < ApplicationComponent
  attr_reader :header, :right_header, :options

  def initialize(header:, right_header: '', options: {})
    @header = header
    @right_header = right_header
    @options = options
  end

  private

  def wrapper_class
    class_names(
      'flex justify-between items-start gap-2 mb-3 w-full',
      options[:wrapper_class]
    )
  end

  def header_class
    class_names(
      '',
      options[:header_class]
    )
  end
end
