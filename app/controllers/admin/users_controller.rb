class Admin::UsersController < ApplicationController
  
  def index
    @users = User.all
    if params[:user_status] == "green"
      @users = User.where("number_of_deleted_posts <= ? AND number_of_deleted_comments <= ? AND number_of_deleted_tags <= ?", 3, 5, 5)
    elsif params[:user_status] == "yellow"
      @users = User.where(
        "number_of_deleted_posts >= ? AND number_of_deleted_posts <= ? OR " \
        "number_of_deleted_comments >= ? AND number_of_deleted_comments <= ? OR " \
        "number_of_deleted_tags >= ? AND number_of_deleted_tags <= ?",
        4, 6, 6, 10, 6, 10
        )
    elsif params[:user_status] == "red"
      @users = User.where(
        "number_of_deleted_posts >= ? AND number_of_deleted_posts <= ? OR " \
        "number_of_deleted_comments >= ? AND number_of_deleted_comments <= ? OR " \
        "number_of_deleted_tags >= ? AND number_of_deleted_tags <= ?",
        7, 9, 11, 15, 11, 15
        )
    elsif params[:user_status] == "gray"
      @users = User.where("number_of_deleted_posts = ? OR number_of_deleted_comments = ? OR number_of_deleted_tags = ?", 10, 16, 16).where(is_admission: false)
    elsif params[:user_status] == "black"
      @users = User.where(is_admission: true)
    end 
    if params[:sort_rule] == "0"
      @users = @users.order(id: :desc)
    elsif params[:sort_rule] == "1"
      @users = @users.order(id: :asc)
    elsif params[:sort_rule] == "2"
      @users = @users.sort{|a, b|b.posts.size <=> a.posts.size }
    elsif params[:sort_rule] == "3"
      @users = @users.sort{|a,b| b.comments.size <=> a.comments.size }
    elsif params[:sort_rule] == "4"
      @users = @users.sort{|a,b| b.tags.size <=> a.tags.size }
    end
    @users = @users.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all
    @comments = @user.comments.all
    @tags = @user.tags.all
  end
  
  def withdraw
  end
  
end
