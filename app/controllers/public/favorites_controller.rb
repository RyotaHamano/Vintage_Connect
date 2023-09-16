class Public::FavoritesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(user_id: current_user.id)
    favorite.save
    redirect_to post_path(@post.id)
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    redirect_to post_path(@post.id)
  end
  
end
