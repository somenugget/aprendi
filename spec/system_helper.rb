require 'rails_helper'
require 'capybara'
require 'capybara/rspec'

Dir[File.join(__dir__, 'system/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :system

  config.around(:each, type: :system) do |ex|
    was_host = Rails.application.default_url_options[:host]
    Rails.application.default_url_options[:host] = Capybara.server_host
    ex.run
    Rails.application.default_url_options[:host] = was_host
  end

  config.prepend_before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end
end
