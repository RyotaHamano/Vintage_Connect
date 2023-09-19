class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def restrict_viewing
    comment = Comment.find(params[:id])
    @post = Post.find(params[:post_id])
    @user = comment.user
    replies = comment.replies.where(reading_status: false)
    comment.update(reading_status: true)
    replies.destroy_all
    @user.number_of_deleted_comments += 1
    @user.save
    @comments = @post.comments.where(reading_status: false)
    @user_comments = @user.comments.where(reading_status: false)
    @user_deleted_comments = @user.comments.where(reading_status: true)
  end
  
end
