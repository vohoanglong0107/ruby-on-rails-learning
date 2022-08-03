class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      handle_authenticated @user
    else
      handle_unauthenticated
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def handle_authenticated user
    if user.activated?
      log_in user
      handle_remember user
      redirect_back_or user
    else
      flash[:warning] = t ".account_not_activated"
      redirect_to root_url
    end
  end

  def handle_remember user
    if params[:session][:remember_me] == Settings.session.remember_me_value
      remember(user)
    else
      forget(user)
    end
  end

  def handle_unauthenticated
    flash.now[:danger] = t ".failure"
    render :new
  end
end
