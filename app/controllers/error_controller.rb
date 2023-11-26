class ErrorController < ApplicationController
  def index
    raise StandardError, 'This is a test error'
  end
end
