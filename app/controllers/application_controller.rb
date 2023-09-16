class ApplicationController < ActionController::Base
  
  def ensure_guest_user
    @user = current_user
    if @user.guest_user?
      redirect_to request.referer, notice:'ログインしてください'
    end
  end
  
end
