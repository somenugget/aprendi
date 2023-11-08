class ApplicationComponent < ViewComponent::Base
  include ActionView::RecordIdentifier
  include Rails.application.routes.url_helpers
end
