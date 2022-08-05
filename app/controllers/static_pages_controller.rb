class StaticPagesController < ApplicationController
  include Pagy::Backend

  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed, page: params[:page]
  end

  def help; end

  def about; end

  def contact; end
end
