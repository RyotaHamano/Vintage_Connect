class Public::TagsController < ApplicationController
  
  def index
    @tags = Tag.where(is_available: false).order(:name)
  end
  
  def search
    selected_tag_ids = params[:tag_ids]
    @tags = Tag.where(id: selected_tag_ids)
    tagged_post_ids = Tagging.where(tag_id: selected_tag_ids).pluck(:post_id)
    @posts = Post.where(reading_status: false).where(id: tagged_post_ids)
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
  
  def narrow
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
