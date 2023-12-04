if ENV['SENTRY_DSN']
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 0.1
    # or
    config.traces_sampler = lambda do |context|
      rack_env = context[:env]

      next 0.05 if rack_env.blank?
      next 0.0 if rack_env['PATH_INFO'].starts_with?('/up')

      0.05
    end
  end
end
