class ServiceWorkerController < ApplicationController
  include ActionView::Helpers::AssetUrlHelper
  include ViteRails::TagHelpers

  skip_after_action :verify_same_origin_request, only: :index

  def index
    response = cached('service-worker') do
      Faraday.get(vite_asset_url('service-worker.js'))
    end

    render body: response.body, content_type: 'application/javascript'
  end
end
