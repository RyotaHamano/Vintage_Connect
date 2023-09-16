class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit, :update, :confirm, :destroy]
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(reading_status: false).order(id: :desc).page(params[:page])
  end
  
  def favorites
    @user = User.find(params[:id])
    @favorite_posts = @user.favorite_posts.where(reading_status: false).sort{|a, b| b.favorites.ids <=> a.favorites.ids }
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end
  
  def confirm
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "退会しました"
    redirect_to root_path
  end
  
  def follow
    @user = User.find(params[:id])
    @users = @user.follow_user
  end
  
  def followed
    @user = User.find(params[:id])
    @users = @user.followed_user
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :most_favorite, :user_image, :introduction)
  end
  
end
