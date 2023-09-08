class Public::CommentsController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    comment = Comment.new(comment_params)
    comment.save
    redirect_to post_path(@post.id)
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to post_path(@post.id)
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:text, :post_id, :top_parent_id, :user_id)
  end
  
end
