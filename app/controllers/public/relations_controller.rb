class Public::RelationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def create
    current_user.follow.create(followed_id: params[:user_id])
    @user = User.find(params[:user_id])
    redirect_to request.referer
  end
  
  def destroy
    current_user.follow.find_by(followed_id: params[:user_id]).destroy
    @user = User.find(params[:user_id])
    redirect_to request.referer
  end
  
end
