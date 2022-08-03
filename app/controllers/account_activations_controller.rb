class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if validate user
      user.activate
      log_in user
      flash[:success] = t ".success"
      redirect_to user
    else
      flash[:danger] = t ".failure"
      redirect_to root_url
    end
  end

  private
  def validate user
    user && !user.activated? && user.authenticated?(:activation, params[:id])
  end
end
