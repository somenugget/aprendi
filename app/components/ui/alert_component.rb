class UI::AlertComponent < ApplicationComponent
  extend Dry::Initializer

  # @!method initialize(variant: :info, message: nil)

  # @!method variant
  # @return [Symbol]
  option :variant, default: proc { :info }

  # @!method message
  # @return [String]
  option :message, default: proc {}

  private

  def render?
    message.present? || content?
  end

  def alert_class
    class_names(shared_class, alert_variant_class)
  end

  def alert_variant_class
    case @variant
    when :info
      'text-blue-800 bg-blue-50 dark:bg-gray-800 dark:text-blue-400'
    when :success
      'text-green-800 bg-green-50 dark:bg-gray-800 dark:text-green-400'
    when :error
      'text-red-800 bg-red-50 dark:bg-gray-800 dark:text-red-400'
    when :warning
      'text-yellow-800 dark:bg-gray-800 dark:text-yellow-300'
    else
      'text-gray-800 dark:bg-gray-800 dark:text-gray-300'
    end
  end

  def shared_class
    'p-4 mb-4 text-sm rounded-lg'
  end
end
