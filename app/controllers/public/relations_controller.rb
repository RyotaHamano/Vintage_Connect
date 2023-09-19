class Public::RelationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def create
    current_user.follow.create(followed_id: params[:user_id])
    @follow_user = User.find(params[:user_id])
  end
  
  def destroy
    current_user.follow.find_by(followed_id: params[:user_id]).destroy
    @follow_user = User.find(params[:user_id])
  end
  
end
