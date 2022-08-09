class UsersController < ApplicationController
  include Pagy::Backend

  before_action :find_user, only: %i(show edit update destroy)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.where activated: true
  end

  def show
    if @user&.activated?
      @pagy, @microposts = pagy @user.microposts.newest
    else
      flash[:danger] = t ".not_found"
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".failure"
      render "new"
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash.now[:danger] = t ".failure"
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failure"
    end
    redirect_to users_path
  end

  def following
    @title = t ".following"
    @user = User.find params[:id]
    @pagy, @users = pagy @user.following, page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t ".followers"
    @user = User.find params[:id]
    @pagy, @users = pagy @user.followers, page: params[:page]
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
