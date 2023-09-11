class Public::TagsController < ApplicationController
  
  def index
    @tags = Tag.where(is_available: false).order(:name)
  end
  
  def search
    if params[:tag_ids].present?
      session[:tag_ids] = params[:tag_ids]
    end
    @tags = Tag.where(id: session[:tag_ids])
    tagged_post_ids = Tagging.where(tag_id: session[:tag_ids]).pluck(:post_id)
    @posts = Post.where(reading_status: false).where(id: tagged_post_ids)
    
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
  
  def create
    tag = Tag.new(tag_params)
    tag.save
    redirect_to tag_select_display_posts_path
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name, :user_id, :is_available)
  end
  
end
