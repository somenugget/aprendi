class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :polynomially_longer, attempts: 5 do |_job, exception|
    Rails.error.report(exception)
  end
end
