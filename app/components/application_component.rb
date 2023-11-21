class ApplicationComponent < ViewComponent::Base
  include ActionView::RecordIdentifier
  include Rails.application.routes.url_helpers
  include Heroicon::Engine.helpers
  include ActionView::Helpers::TagHelper
end
