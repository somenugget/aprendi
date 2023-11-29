ActionMailer::MailDeliveryJob.retry_on StandardError, wait: :exponentially_longer, attempts: Float::INFINITY

Rails.application.configure do
  config.good_job = {
    preserve_job_records: true,
    retry_on_unhandled_error: true,
    on_thread_error: ->(exception) { Rails.error.report(exception) },
    execution_mode: :async,
    queues: '*',
    max_threads: 5,
    poll_interval: 30,
    shutdown_timeout: 25,
    enable_cron: true,
    cron: {
      example: {
        cron: '0 * * * *',
        class: 'DailyReminderJob'
      },
    },
    dashboard_default_locale: :en,
  }
end
