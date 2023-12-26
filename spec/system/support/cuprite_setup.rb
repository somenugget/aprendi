require 'capybara/cuprite'

# Then, we need to register our driver to be able to use it later
# with #driven_by method.#
# NOTE: The name :cuprite is already registered by Rails.
# See https://github.com/rubycdp/cuprite/issues/180
Capybara.register_driver(:better_cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    # See additional options for Dockerized environment in the respective section of this article
    browser_options: { 'no-sandbox' => nil },
    # Increase Chrome startup wait time (required for stable CI builds)
    process_timeout: 10,
    # Enable debugging capabilities
    inspector: true,
    headless: ActiveModel::Type::Boolean.new.cast(ENV['HEADLESS']).presence || ENV['CI'].presence || false
  )
end

# Configure Capybara to use :better_cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite
