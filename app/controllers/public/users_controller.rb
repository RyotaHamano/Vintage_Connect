class Public::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(reading_status: false)
   
  end

  def edit
  end
  
  def update
  end
  
  def confirm
  end
  
  def destroy
  end
  
  def follows
  end
  
  def followeds
  end
  
end
