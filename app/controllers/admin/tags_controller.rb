class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @tags = Tag.where(is_available: false).order(id: :desc)
    @disabled_tags = Tag.where(is_available: true).order(id: :desc)
    @tag = Tag.new
    if params[:sort_rule] == "1"
      @tags = Tag.where(is_available: false).order(:name)
      @disabled_tags = Tag.where(is_available: true).order(:name)
    end
  end
  
  def disable
    tag = Tag.find(params[:id])
    tag.update(is_available: true)
    user = tag.user
    user.number_of_deleted_tags += 1
    user.save
    tag.taggings.destroy_all
    redirect_to request.referer
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name, :is_available)
  end
  
end
