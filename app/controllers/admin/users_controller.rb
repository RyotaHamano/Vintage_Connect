class Admin::UsersController < ApplicationController
  
  def index
    @users = User.where(is_admission: false)
    if params[:user_status] == "all"
      @users = User.all
    elsif params[:user_status] == "green"
      @users = @users.where("number_of_deleted_posts <= ? AND number_of_deleted_comments <= ? AND number_of_deleted_tags <= ?", 3, 5, 5)
    elsif params[:user_status] == "yellow"
      @users = @users.where(
        "number_of_deleted_posts >= ? AND number_of_deleted_posts <= ? OR " \
        "number_of_deleted_comments >= ? AND number_of_deleted_comments <= ? OR " \
        "number_of_deleted_tags >= ? AND number_of_deleted_tags <= ?",
        4, 6, 6, 10, 6, 10
        )
    elsif params[:user_status] == "red"
      @users = @users.where(
        "number_of_deleted_posts >= ? AND number_of_deleted_posts <= ? OR " \
        "number_of_deleted_comments >= ? AND number_of_deleted_comments <= ? OR " \
        "number_of_deleted_tags >= ? AND number_of_deleted_tags <= ?",
        7, 9, 11, 15, 11, 15
        )
    elsif params[:user_status] == "gray"
      @users = @users.where("number_of_deleted_posts >= ? OR number_of_deleted_comments >= ? OR number_of_deleted_tags >= ?", 10, 16, 16).where(is_admission: false)
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
    @posts = @user.posts.all.order(id: :desc)
    @comments = @user.comments.where(reading_status: false)
    @deleted_comments = @user.comments.where(reading_status: true)
    @tags = @user.tags.where(is_available: false)
    @disabled_tags = @user.tags.where(is_available: true)
    if params[:reading_status] == "0"
      @posts = @posts.where(reading_status: false)
    elsif params[:reading_status] == "1"
      @posts = @posts.where(reading_status: true)
    end
    if params[:sort_rule] == "0"
      @posts = @posts.order(id: :desc)
    elsif params[:sort_rule] == "1"
      @posts = @posts.order(id: :asc)
    end
    
  end
  
  def withdraw
    user = User.find(params[:id])
    posts = user.posts.where(reading_status: false)
    comments = user.comments.where(reading_status: false)
    user.update(is_admission: true)
    posts.each do |post_item|
      post_item.update(reading_status: true)
    end
    comments.each do |comment|
      comment.update(reading_status: true)
    end
    redirect_to admin_user_path(user.id)
  end
  
end
