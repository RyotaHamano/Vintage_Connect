class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only:[:create]

  def index
    @tags = Tag.where(is_available: false).order(:name)
  end

  def search
    if params[:tag_ids].present?
      session[:tag_ids] = params[:tag_ids]
    end
    @tags = Tag.where(id: session[:tag_ids])
    tagged_post_ids = Tagging.where(tag_id: session[:tag_ids]).pluck(:post_id)
    if params[:sort_rule].present?
      @posts = Post.where(reading_status: false).where(id: tagged_post_ids).ordered_sort(params[:sort_rule])
    else
      @posts = Post.where(reading_status: false).where(id: tagged_post_ids).order(id: :desc)
    end

    if params[:shop_genre].present?
      @posts = @posts.where(shop_genre: params[:shop_genre])
    end
    if params[:prefecture].present?
      @posts = @posts.where(prefecture: params[:prefecture])
    end
    @posts = @posts.page(params[:page])
  end

  def create
    tag = Tag.new(tag_params)
    tag.save
    @tags = Tag.where(is_available: false).order(:name)
    @tag = Tag.new
    if params[:tag][:post_id].present?
      @post = Post.find(params[:tag][:post_id])
    end
    if request.referer.include?('tag_select_display')
      @render_select = 'display'
    else
      @render_select = 'edit'
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :user_id, :is_available)
  end

end
