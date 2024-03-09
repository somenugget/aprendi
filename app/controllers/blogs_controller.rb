class BlogsController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'blog'

  def privacy_policy; end

  def terms_and_conditions; end
end
