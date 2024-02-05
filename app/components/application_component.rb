class ApplicationComponent < ViewComponent::Base
  include ActionView::RecordIdentifier
  include Rails.application.routes.url_helpers
  include Heroicon::Engine.helpers
  include ActionView::Helpers::TagHelper

  private

  def class_names(*args)
    TailwindMerge::Merger.new.merge(super)
  end
end
