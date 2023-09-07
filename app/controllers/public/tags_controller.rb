class Public::TagsController < ApplicationController
  
  def index
  end
  
  def search
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
