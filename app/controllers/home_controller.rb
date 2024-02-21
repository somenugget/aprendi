class HomeController < ApplicationController
  helper Heroicon::Engine.helpers

  layout 'landing'

  def index; end
end
