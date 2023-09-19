class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:sort_rule].present?
      @posts = Post.all.ordered_sort(params[:sort_rule])
    else
      @posts = Post.all.order(id: :desc)
    end
    if params[:reading_status].present?
      @posts = @posts.where(reading_status: params[:reading_status])
    end
    if params[:shop_genre].present?
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture].present?
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    @posts = @posts.page(params[:page])
  end
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comments = @post.comments.where(reading_status: false, top_parent_id: nil)
  end
  
  def restrict_viewing
    post_item = Post.find(params[:id])
    user = post_item.user
    post_item.reading_status = true
    post_item.save
    user.number_of_deleted_posts += 1
    user.save
    flash[:notice] = "閲覧制限しました"
    redirect_to admin_posts_path
  end
  
end
