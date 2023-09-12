class Admin::PostsController < ApplicationController
  
  def index
    @posts = Post.all
    if params[:reading_status].present?
      @posts = @posts.where(reading_status: params[:reading_status])
    end
    if params[:shop_genre].present?
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture].present?
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    if params[:sort_rule] == "0"
      @posts = @posts.order(id: :desc)
    elsif params[:sort_rule] == "1"
      @posts = @posts.order(id: :asc)
    elsif params[:sort_rule] == "2"
      @posts = @posts.order(rate: :desc)
    elsif params[:sort_rule] == "3"
      @posts = @posts.includes(:favorites).sort{|a,b| b.favorites.size <=> a.favorites.size }
    end
    @posts = @posts.page(params[:page])
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.where(reading_status: false, top_parent_id: nil)
  end
  
  def restrict_viewing
    post_item = Post.find(params[:id])
    user = post_item.user
    post_item.reading_status = true
    post_item.save
    user.number_of_deleted_posts += 1
    user.save
    redirect_to admin_posts_path
  end
  
end
