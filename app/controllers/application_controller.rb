class ApplicationController < ActionController::Base
  
  def ensure_guest_user
    @user = current_user
    if @user.guest_user?
      redirect_to request.referer, notice:'新規登録・ログインしてください'
    end
  end
  
  def admin_ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to request.referer, notice:'ゲストアカウントは操作不可能です'
    end
  end
  
end
