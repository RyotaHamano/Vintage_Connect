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
  end
  
  def tag_select
  end
  
  def preview
  end
  
  def complete
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
  
end
