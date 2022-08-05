class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".login_required"
    redirect_to login_url
  end
end
