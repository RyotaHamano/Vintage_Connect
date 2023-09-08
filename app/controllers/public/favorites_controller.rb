class Public::FavoritesController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorite.new(user_id: current_user.id)
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
