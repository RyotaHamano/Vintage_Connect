class Admin::CommentsController < ApplicationController
  
  def restrict_viewing
    comment = Comment.find(params[:id])
    user = comment.user
    comment.update(reading_status: true)
    user.number_of_deleted_comments += 1
    user.save
    redirect_to request.referer
  end
  
end
