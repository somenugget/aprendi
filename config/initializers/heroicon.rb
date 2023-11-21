# frozen_string_literal: true

Heroicon.configure do |config|
  config.variant = :solid # Options are :solid, :outline and :mini
  config.default_class = { solid: 'h-5 w-5', outline: 'h-6 w-6', mini: 'h-4 w-4' }
end
