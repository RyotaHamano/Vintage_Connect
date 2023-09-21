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
  
  def tmp_file_access
    if session[:temporary_image_pathes].present?
      @temp_image_pathes = session[:temporary_image_pathes]
      @temp_image_pathes.each do |image_path| # 一時ファイルからファイルを呼び出しActiveStorageに格納
        File.open(image_path)
      end
    end
  end
  
end
