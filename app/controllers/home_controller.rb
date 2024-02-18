class HomeController < ApplicationController
  helper Heroicon::Engine.helpers

  layout 'landing'

  def index
    redirect_to dashboard_path if user_signed_in?
  end
end
