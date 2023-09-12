class Admin::TagsController < ApplicationController
  
  def index
    @tags = Tag.where(is_available: false).order(id: :desc)
    @disabled_tags = Tag.where(is_available: true).order(id: :desc)
    @tag = Tag.new
    if params[:sort_rule] == "1"
      @tags = @tags.order(:name)
      @disabled_tags = @disabled_tags.order(:name)
    end
  end
  
  def create
    tag = Tag.new(tag_params)
    tag.save
    redirect_to admin_tags_path
  end
  
  def disable
    tag = Tag.find(params[:id])
    tag.update(is_available: true)
    if tag.user_id.exists?
      user = tag.user
      user.number_of_deleted_tags += 1
      user.save
    end 
    redirect_to request.referer
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name, :is_available)
  end
  
end
