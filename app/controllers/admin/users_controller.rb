class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :admin_ensure_guest_user, only: [:show, :withdraw]
  
  def index
    @users = User.where(is_admission: false).where.not(email: "guest@example.com")
    # ユーザーステータスによって空配列に格納
    green_users = []
    yellow_users = []
    red_users = []
    gray_users = []
    @users.each do |user|
      if user.green?
        green_users << user
      elsif user.yellow?
        yellow_users << user
      elsif user.red?
        red_users << user
      elsif user.gray?
        gray_users << user
      end
    end
    if params[:user_status] == "all"
      @users = User.where(is_admission: false).where.not(email: "guest@example.com")
    elsif params[:user_status] == "green"
      @users = green_users
    elsif params[:user_status] == "yellow"
      @users = yellow_users
    elsif params[:user_status] == "red"
      @users = red_users
    elsif params[:user_status] == "gray"
      @users = gray_users
    elsif params[:user_status] == "black"
      @users = User.where(is_admission: true)
    end 
    if params[:sort_rule] == "0"
      @users = @users.sort{|a, b|b.id <=> a.id }
    elsif params[:sort_rule] == "1"
      @users = @users.sort{|a, b|a.id <=> b.id }
    elsif params[:sort_rule] == "2"
      @users = @users.sort{|a, b|b.posts.size <=> a.posts.size }
    elsif params[:sort_rule] == "3"
      @users = @users.sort{|a,b| b.comments.size <=> a.comments.size }
    elsif params[:sort_rule] == "4"
      @users = @users.sort{|a,b| b.tags.size <=> a.tags.size }
    end
      @users = Kaminari.paginate_array(@users).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all.order(id: :desc)
    @comments = @user.comments.where(reading_status: false)
    @deleted_comments = @user.comments.where(reading_status: true)
    @tags = @user.tags.where(is_available: false).order(id: :desc)
    @disabled_tags = @user.tags.where(is_available: true).order(id: :desc)
    if params[:sort_rule] == "0"
      @posts = @user.posts.all.order(id: :desc)
    elsif params[:sort_rule] == "1"
      @posts = @user.posts.all.order(id: :asc)
    end
    if params[:reading_status] == "0"
      @posts = @posts.where(reading_status: false)
    elsif params[:reading_status] == "1"
      @posts = @posts.where(reading_status: true)
    end
    
  end
  
  # 強制退会処理（投稿＆コメント全削除）
  def withdraw
    @user = User.find(params[:id])
    posts = @user.posts.where(reading_status: false)
    comments = @user.comments.where(reading_status: false)
    @user.update(is_admission: true)
    posts.each do |post_item|
      post_item.update(reading_status: true)
    end
    comments.each do |comment|
      comment.update(reading_status: true)
    end
  end
  
end
