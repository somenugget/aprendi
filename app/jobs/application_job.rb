class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :polynomially_longer, attempts: 5 do |_job, exception|
    Rails.error.report(exception)
  end

  # Schedules the job to be performed sometime in the next 0-120 seconds.
  def self.perform_sometime_later(*args, **kwargs)
    set(wait: rand(0..120).seconds).perform_later(*args, **kwargs)
  end
end
