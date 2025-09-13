class HomeController < ApplicationController
  helper Heroicons::Engine.helpers

  layout 'landing'

  def index; end
end
