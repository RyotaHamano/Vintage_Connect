class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def create
    @post = Post.find(params[:post_id])
    comment = Comment.new(comment_params)
    comment.save
    @comments = @post.comments.where(reading_status: false, top_parent_id: nil)
    @comment = Comment.new
    @reply = Comment.new
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    comment = Comment.find(params[:id])
    comment.destroy
    @comments = @post.comments.where(reading_status: false, top_parent_id: nil)
    @comment = Comment.new
    @reply = Comment.new
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:text, :post_id, :top_parent_id, :user_id)
  end
  
end
