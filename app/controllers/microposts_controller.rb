class MicropostsController < ApplicationController
  include Pagy::Backend

  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      handle_save_success
    else
      handle_save_failure
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".success"
    else
      flash[:warning] = t ".failure"
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end

  def handle_save_success
    flash[:success] = t ".success"
    redirect_to root_url
  end

  def handle_save_failure
    flash.now[:danger] = t ".failure"
    @pagy, @feed_items = pagy current_user.feed, page: params[:page]
    render "static_pages/home"
  end
end
