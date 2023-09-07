class Public::PostsController < ApplicationController
  
  def index
    @posts = Post.where(reading_status: false)
    if params[:sort_rule]
      @posts = @posts.sort_branch(params[:sort_rule])
    end
    if params[:shop_genre]
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture]
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    @posts = @posts.page(params[:page])
  end
  
  def search
  end
  
  def new
    if session[:new_post]
      @post = Post.new(session[:new_post])
    else
      @post = Post.new
    end
  end
  
  def tag_select
    @post = Post.new(post_params)
    session[:new_post] = @post
    redirect_to tag_select_display_posts_path
  end
  
  def tag_select_display
    @post = Post.new(session[:new_post])
    @tags = Tag.where(is_available: false)
    @tag = Tag.new
  end
  
  def preview
    @post = Post.new(session[:new_post])
    @tags = Tag.where(id: params[:tag_ids])
    session[:tag_ids] = params[:tag_ids]
  end
  
  def create
    @post = Post.new(session[:new_post])
    @tags = Tag.where(id: session[:tag_ids])
    @post.save
    @tags.each do |tag|
      tagging = Tagging.new
      tagging.post_id = @post.id
      tagging.tag_id = tag.id
      tagging.save
    end
    session.delete(:new_post)
    session.delete(:tag_ids)
    redirect_to post_path(@post.id)
  end

  def show
  end

  def edit
  end
  
  def edit_tag
  end
  
  def edit_preview
  end
  
  def update
  end
  
  def destroy
  end
  
  private
  
  def post_params
    params.require(:post).permit(:shop_name, :shop_genre, :prefecture, :address, :post_images, :review, :rate, :reading_status, :user_id)
  end
  
end
