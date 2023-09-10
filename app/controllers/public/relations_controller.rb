class Public::RelationsController < ApplicationController
  
  def create
    current_user.follow.create(followed_id: params[:user_id])
    @user = User.find(params[:user_id])
  end
  
  def destroy
    current_user.follow.find_by(followed_id: params[:user_id]).destroy
    @user = User.find(params[:user_id])
  end
  
end
