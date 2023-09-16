class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def restrict_viewing
    comment = Comment.find(params[:id])
    user = comment.user
    replies = comment.replies
    comment.update(reading_status: true)
    replies.destroy_all
    user.number_of_deleted_comments += 1
    user.save
    redirect_to request.referer
  end
  
end
