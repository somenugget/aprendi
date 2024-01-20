ActionMailer::MailDeliveryJob.retry_on StandardError, wait: :polynomially_longer, attempts: 10

Rails.application.configure do
  config.good_job = {
    cleanup_preserved_jobs_before_seconds_ago: 1.day,
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
