class ApplicationComponent < ViewComponent::Base
  include ActionView::RecordIdentifier
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TagHelper

  delegate :heroicon, :icon, to: :helpers

  private

  def class_names(*args)
    TailwindMerge::Merger.new.merge(super)
  end
end
