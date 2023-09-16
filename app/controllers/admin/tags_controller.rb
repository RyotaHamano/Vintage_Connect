class Admin::TagsController < ApplicationController
  
  def index
    @tags = Tag.where(is_available: false).order(id: :desc)
    @disabled_tags = Tag.where(is_available: true).order(id: :desc)
    @tag = Tag.new
    if params[:sort_rule] == "1"
      @tags = Tag.where(is_available: false).order(:name)
      @disabled_tags = Tag.where(is_available: true).order(:name)
    end
  end
  
  def create
    tag = Tag.new(tag_params)
    tag.user_id = nil
    if tag.save
      redirect_to admin_tags_path
    else
    # エラーがある場合、エラーを調べることができます
      flash[:error] = tag.errors.full_messages.to_sentence
    end
    redirect_to admin_tags_path
  end
  
  def disable
    tag = Tag.find(params[:id])
    tag.update(is_available: true)
    if tag.user_id != nil
      user = tag.user
      user.number_of_deleted_tags += 1
      user.save
    end 
    tag.taggings.destroy_all
    redirect_to request.referer
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name, :is_available)
  end
  
end
